grunt  = require("grunt")
spawn  = require("child_process").spawn
read   = grunt.file.read
mkdir  = grunt.file.mkdir
clear  = grunt.file.delete
_      = require("underscore")

runGruntTask = (done) ->
  spawn("grunt",
    [
      "datauri",
      "--gruntfile", "spec/Gruntfile.coffee"
    ],
    {stdio: 'inherit'}
  ).on("exit", -> done())

beforeEach -> mkdir @workspacePath = "spec/tmp"
afterEach  -> clear "spec/tmp/"

describe "datauri", ->

  describe "generating the .scss variables file", ->
    Given (done) -> runGruntTask(done)
    When -> @expected = read("spec/_expected_datauri_variables.scss")
    When -> @actual   = read("spec/tmp/_datauri_variables.scss")
    Then -> @actual == @expected

  # describe "generating the .scss variables file using a map", ->
  #   Given (done) ->
  #     config = _.clone(@config)
  #     config.datauri.sut.options.useMap = "image-map"
  #     runGruntTask("datauri", config, done)
  #   When -> @expected = read("spec/_expected_datauri_map_variables.scss")
  #   When -> @actual   = read("spec/tmp/_datauri_variables.scss")
  #   Then -> @actual == @expected
