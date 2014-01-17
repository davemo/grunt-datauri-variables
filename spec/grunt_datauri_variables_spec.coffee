grunt  = require("grunt")
spawn  = require("child_process").spawn
read   = grunt.file.read
mkdir  = grunt.file.mkdir
clear  = grunt.file.delete

runGruntTask = (task, config, done) ->
  spawn("grunt",
    [
      task,
      "--config", JSON.stringify(config),
      "--tasks", "../tasks"
      "--gruntfile", "spec/Gruntfile.coffee"
    ],
    {stdio: 'inherit'}
  ).on("exit", -> done())

beforeEach -> mkdir @workspacePath = "spec/tmp"
afterEach  -> clear "spec/tmp/"

describe "datauri", ->

  Given ->
    @config =
      datauri:
        sut:
          files:
            "tmp/_datauri_variables.scss": "fixtures/**/*.{png,jpg,gif,svg}"
          options:
            colors:
              main: "red"
              alt: "green"
              header: "blue"

  describe "generating the .scss variables file", ->
    Given (done) -> runGruntTask("datauri", @config, done)
    When -> @expected = read("spec/_expected_datauri_variables.scss")
    When -> @actual   = read("spec/tmp/_datauri_variables.scss")
    Then -> @actual == @expected
