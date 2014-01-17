#
# * grunt-datauri-variables
# * https://github.com/davemo/grunt-datauri-variables
# *
# * Copyright (c) 2013 David Mosher
# * Licensed under the MIT license.
#

fs      = require("fs")
path    = require("path")
_       = require("underscore")
datauri = require("datauri")

"use strict"

module.exports = (grunt) ->

  _.templateSettings = {interpolate : /\{\{(.+?)\}\}/g}
  variableTemplate   = _.template('${{ varname }}: "{{base64_data}}";\n')

  isColorWord = (val) ->
    acceptable = [
      "black", "silver", "gray", "white", "maroon", "red", "purple", "fuchsia", "green", "lime", "olive",
      "yellow", "navy", "blue", "teal", "aqua", "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige",
      "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "burlywood", "cadetblue", "chartreuse",
      "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod",
      "darkgray", "darkgreen", "darkgrey", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid",
      "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise",
      "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite",
      "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "green", "greenyellow", "grey",
      "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen",
      "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgreen",
      "lightgrey", "lightpink", "lightsalmon", "lightseagreen", "lightskyblue", "lightslategray", "lightslategrey",
      "lightsteelblue", "lightyellow", "lime", "limegreen", "linen", "magenta", "maroon", "mediumaquamarine",
      "mediumblue", "mediumorchid", "mediumpurple", "mediumseagreen", "mediumslateblue", "mediumspringgreen",
      "mediumturquoise", "mediumvioletred", "midnightblue", "mintcream", "mistyrose", "moccasin", "navajowhite", "navy",
      "oldlace", "olive", "olivedrab", "orange", "orangered", "orchid", "palegoldenrod", "palegreen", "paleturquoise",
      "palevioletred", "papayawhip", "peachpuff", "peru", "pink", "plum", "powderblue", "purple", "red", "rosybrown",
      "royalblue", "saddlebrown", "salmon", "sandybrown", "seagreen", "seashell", "sienna", "silver", "skyblue",
      "slateblue", "slategray", "slategrey", "snow", "springgreen", "steelblue", "tan", "teal", "thistle", "tomato",
      "turquoise", "violet", "wheat", "white", "whitesmoke", "yellow", "yellowgreen"
    ]
    return true if acceptable.indexOf(val) > -1
    false

  isHex = (val) ->
    (/^[0-9a-f]{3}(?:[0-9a-f]{3})?$/i).test val

  getColorConfig = (str) ->
    colors = str.match(/\.colors\-([^\.]+)/i)
    colorObj = {}
    if colors
      colors = colors[1].split("-")
      colors.forEach (color, i) ->
        if isHex(color)
          colorObj[i] = "#" + color
        else colorObj[color] = color if isColorWord(color)
      colorObj
    else
      colorObj

  grunt.registerMultiTask "datauri", "Generates .scss datauri variables for .{png,gif,jpg} and .svg, and replaces ", ->

    options = @options
      varPrefix: 'data-image-'
      varSuffix: ''
      colors: undefined

    lines = []

    _(@files).each (file) ->
      [imageSources, dest] = [file.src, file.dest]

      _(imageSources).each (imagePath) ->
        unless grunt.file.exists(imagePath)
          grunt.log.warn "Source file \"" + imagePath + "\" not found."
          return false

        lines.push(
          variableTemplate(
            varname: "#{options.varPrefix}#{path.basename(imagePath).split('.')[0]}#{options.varSuffix}"
            base64_data: datauri(imagePath)
          )
        )

        fileNameColors = getColorConfig(imagePath)

        if _(fileNameColors).keys().length
          _(_.keys(fileNameColors)).each (color) ->

            svgContents = fs.readFileSync(imagePath).toString('utf-8');
            colorizedSvgContents = svgContents.replace(/(<svg[^>]+>)/im, '$1<style type="text/css">circle, ellipse, line, path, polygon, polyline, rect, text { fill: ' + options.colors[color] + ' !important; }</style>' )

            lines.push(
              variableTemplate(
                varname: "#{options.varPrefix}#{path.basename(imagePath).split('.')[0]}#{options.varSuffix}-#{color}"
                base64_data: "data:image/svg+xml;base64,#{new Buffer(colorizedSvgContents).toString('base64')}"
              )
            )

      grunt.file.write(dest, lines.join(""))
      grunt.log.writeln "File #{dest} created."
      grunt.log.writeln "Encoded and inlined #{lines.length} lines."
