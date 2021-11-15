module.exports = (grunt) ->

  grunt.loadTasks "../tasks"

  grunt.initConfig
    datauri:
      variable_map_scenario:
        files:
          "tmp/_datauri_variables.scss": "fixtures/**/*.{png,jpg,gif,svg}"
        options:
          useMap: "image-map"
          colors:
            main: "red"
            alt: "green"
            header: "blue"
