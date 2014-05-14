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

  getStrokeConfig = (str) ->
    strokes = str.match(/\.strokes\-([^\.]+)/i)
    strokeObj = {}
    if strokes
      strokes = strokes[1].split("-")
      strokes.forEach (stroke, i) ->
        if isHex(stroke)
          strokeObj[i] = "#" + stroke
        else strokeObj[stroke] = stroke
      strokeObj
    else
      strokeObj

  grunt.registerMultiTask "datauri", "Generates .scss datauri variables for .{png,gif,jpg} and .svg, and replaces color definitions in .svg files.", ->

    options = @options
      varPrefix: 'data-image-'
      varSuffix: ''
      colors: undefined
      strokes: undefined

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

        fileNameStrokes = getStrokeConfig(imagePath)

        if _(fileNameStrokes).keys().length
          _(_.keys(fileNameStrokes)).each (stroke) ->

            svgContents = fs.readFileSync(imagePath).toString('utf-8');
            colorizedSvgContents = svgContents.replace(/(<svg[^>]+>)/im, '$1<style type="text/css">circle, ellipse, line, path, polygon, polyline, rect, text { stroke: ' + options.strokes[stroke] + ' !important; }</style>' )

            lines.push(
              template(
                varname: "#{options.varPrefix}#{path.basename(imagePath).split('.')[0]}#{options.varSuffix}-#{stroke}-stroke"
                base64_data: "data:image/svg+xml;base64,#{new Buffer(colorizedSvgContents).toString('base64')}"
              )
            )

      grunt.file.write(dest, lines.join(""))
      grunt.log.writeln "File #{dest} created."
      grunt.log.writeln "Encoded and inlined #{lines.length} lines."
