module.exports = (grunt) ->

  grunt.loadTasks "../tasks"

  grunt.initConfig
    datauri:
      basic_scenario:
        files:
          "tmp/_datauri_variables.scss": "fixtures/**/*.{png,jpg,gif,svg}"
        options:
          colors:
            main: "red"
            alt: "green"
            header: "blue"