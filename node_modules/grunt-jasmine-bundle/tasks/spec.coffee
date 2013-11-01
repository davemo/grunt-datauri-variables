# spec
#
# Options:
#   helpers - "spec/helpers/**/*.{js,coffee}" - a glob (or array of globs) to your spec helpers
#   specs - "spec/**/*.{js,coffee}" - a glob (or array of globs) to your specs
#   minijasminenode - {} - an object to set or override any options to minijasmine node. See options here: https://github.com/juliemr/minijasminenode#usage
module.exports = (grunt) ->
  _ = grunt.util._

  grunt.registerMultiTask "spec", "run unit specs with Jasmine", (target) ->
    done = @async()

    jasmine = require("minijasminenode")
    #duck-punch the heck out of global jasmine:
    global.context = global.describe
    global.xcontext = global.xdescribe
    require("jasmine-given")
    require("jasmine-only")
    require("jasmine-before-all")
    require("jasmine-stealth")

    defaultConfig =
      specs: grunt.file.expand(@data.helpers || "spec/helpers/**/*.{js,coffee}").concat(grunt.file.expand(@data.specs || "spec/**/*.{js,coffee}"))
      onComplete: (runner, log) ->
        done(runner.results().failedCount == 0)

    jasmine.executeSpecs(_({}).extend(defaultConfig, @data.minijasminenode))

  # because this is a multi-task, it's necessary to have a default task defined
  grunt.config("spec", default: {}) unless grunt.config("spec")?

