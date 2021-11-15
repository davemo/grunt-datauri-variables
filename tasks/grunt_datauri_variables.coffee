#
# * grunt-datauri-variables
# * https://github.com/davemo/grunt-datauri-variables
# *
# * Copyright (c) 2013 David Mosher
# * Licensed under the MIT license.
#

fs      = require("fs")
path    = require("path")
datauri = require("datauri/sync")
_       = require("underscore")

"use strict"

module.exports = (grunt) ->

  _.templateSettings = {interpolate : /\{\{(.+?)\}\}/g}
  variableTemplate   = _.template('${{ varname }}: "{{base64_data}}";\n')
  mapTemplate = _.template('${{ mapname }}: (\n{{ vars }}\n);\n')
  mapVariableTemplate = _.template('{{ varname }}: "{{base64_data}}",')

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
        else colorObj[color] = color
      colorObj
    else
      colorObj

  grunt.registerMultiTask "datauri", "Generates .scss datauri variables for .{png,gif,jpg} and .svg, and replaces color definitions in .svg files.", ->

    options = @options
      varPrefix: 'data-image-'
      varSuffix: ''
      colors: undefined
      useMap: false

    lines = []

    _(@files).each (file) ->
      [imageSources, dest] = [file.src, file.dest]

      _(imageSources).each (imagePath) ->
        unless grunt.file.exists(imagePath)
          grunt.log.warn "Source file \"" + imagePath + "\" not found."
          return false

        template = if options.useMap then mapVariableTemplate else variableTemplate

        lines.push(
          template(
            varname: "#{options.varPrefix}#{path.basename(imagePath).split('.')[0]}#{options.varSuffix}"
            base64_data: datauri(imagePath).content
          )
        )

        fileNameColors = getColorConfig(imagePath)

        if _(fileNameColors).keys().length
          _(_.keys(fileNameColors)).each (color) ->

            svgContents = fs.readFileSync(imagePath).toString('utf-8');
            colorizedSvgContents = svgContents.replace(/(<svg[^>]+>)/im, '$1<style type="text/css">circle, ellipse, line, path, polygon, polyline, rect, text { fill: ' + options.colors[color] + ' !important; }</style>' )

            lines.push(
              template(
                varname: "#{options.varPrefix}#{path.basename(imagePath).split('.')[0]}#{options.varSuffix}-#{color}"
                base64_data: "data:image/svg+xml;base64,#{new Buffer.from(colorizedSvgContents).toString('base64')}"
              )
            )

      if options.useMap
        grunt.file.write(dest, mapTemplate(
          mapname: options.useMap
          vars: lines.join("\n")
        ))
      else
        grunt.file.write(dest, lines.join(""))

      grunt.log.writeln "File #{dest} created."
      grunt.log.writeln "Encoded and inlined #{lines.length} lines."
