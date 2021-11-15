#
# * grunt-datauri-variables
# * https://github.com/davemo/grunt-datauri-variables
# *
# * Copyright (c) 2013 David Mosher
# * Licensed under the MIT license.
#
"use strict"
module.exports = (grunt) ->

  grunt.loadNpmTasks "grunt-jasmine-bundle"

  grunt.initConfig
    spec:
      e2e:
        options:
          minijasminenode:
            showColors: true

  grunt.registerTask "default", "spec"