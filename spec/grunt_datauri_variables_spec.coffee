grunt  = require("grunt")
spawn  = require("child_process").spawn
read   = grunt.file.read
mkdir  = grunt.file.mkdir
clear  = grunt.file.delete

runGruntTaskScenario = (scenario, done) ->
  spawn("grunt",
    [
      "datauri",
      "--gruntfile", "spec/Gruntfile.#{scenario}.coffee"
    ],
    {stdio: 'inherit'}
  ).on("exit", -> done())

beforeEach -> mkdir @workspacePath = "spec/tmp"
afterEach  -> clear "spec/tmp"

describe "datauri", ->

  describe "generating the .scss variables file", ->
    Given (done) -> runGruntTaskScenario("basic", done)
    When -> @expected = read("spec/_expected_datauri_variables.scss")
    When -> @actual   = read("spec/tmp/_datauri_variables.scss")
    Then -> @actual == @expected

  describe "generating the .scss variables file using a map", ->
    Given (done) -> runGruntTaskScenario("variable_map", done)
    When -> @expected = read("spec/_expected_datauri_map_variables.scss")
    When -> @actual   = read("spec/tmp/_datauri_variables.scss")
    Then -> @actual == @expected
