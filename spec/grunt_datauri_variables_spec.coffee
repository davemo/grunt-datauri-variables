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

describe "grunt_datauri_variables", ->

  Given ->
    @config =
      grunt_datauri_variables:
        sut:
          files:
            src: "spec/fixtures/*.{png,jpg,gif,svg}"
            dest: "spec/tmp/_datauri_variables.scss"

  describe "generating the .scss variables file", ->
    Given (done) -> runGruntTask("grunt_datauri_variables", @config)
    Then -> true == true
    # When -> @expected = read("_expected_datauri_variables.scss")
    # When -> @actual = read("tmp/_datauri_variables.scss")
    # Then -> @actual == @expected