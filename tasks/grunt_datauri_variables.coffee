#
# * grunt-datauri-variables
# * https://github.com/davemo/grunt-datauri-variables
# *
# * Copyright (c) 2013 David Mosher
# * Licensed under the MIT license.
#

fs     = require "fs"
path   = require "path"
_      = require "underscore"

"use strict"

module.exports = (grunt) ->

  grunt.registerMultiTask "grunt_datauri_variables", "Generates .scss datauri variables for .{png,gif,jpg} and .svg", ->

    colors = @options(colors: undefined).colors

    # _(@files).each (files) ->

    #   src = files.src[0]
    #   dest = files.dest
    #   unless grunt.file.exists(src)
    #     grunt.log.warn "Source file \"" + src + "\" not found."
    #     return false

    #   content  = grunt.file.read(src)

    #   # grunt.file.write filename, content
    #   grunt.log.writeln "read #{src} file"
    #   # grunt.log.writeln "File #{filename} created."

    # fs.writeFileSync
    grunt.log.writeln "done processing #{@files.length} images"
