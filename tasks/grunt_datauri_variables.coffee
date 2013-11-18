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

  grunt.registerMultiTask "datauri", "Generates .scss datauri variables for .{png,gif,jpg} and .svg", ->

    options = @options
      varPrefix: 'data-image-'
      varSuffix: ''

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

      grunt.file.write(dest, lines.join(""))
      grunt.log.writeln "File #{dest} created."
      grunt.log.writeln "Encoded and inlined #{lines.length} images."
