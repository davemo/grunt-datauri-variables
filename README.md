# grunt-datauri-variables

[![Build Status](https://travis-ci.org/davemo/grunt-datauri-variables.png?branch=master)](https://travis-ci.org/davemo/grunt-datauri-variables)


> Generates .scss datauri variables for .{png,gif,jpg} and .svg

## Intended Use

## Why would I use this?

## How would I integrate this task?

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-datauri-variables --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-datauri-variables');
```

## The "datauri_variables" task

### Overview
In your project's Gruntfile, add a section named `datauri_variables` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  datauri_variables: {
    options: {
      colors: {
        red: "#FF0000",
        green: "#00FF00",
        blue: "#0000FF"
      },
    },
    your_target: {
      files: {
        src: "images/**/*.{png,jpg,gif,svg}"
        dest: "generated/_datauri_variables.scss"
      }
    },
  },
})
```

### Sample Output

Given the configuration in the Overview section above, you can expect `grunt datauri_variables` to output the following to `generated/_datauri_variables.scss`

```shell
cat generated/_datauri_variables.scss

```

### Options

#### options.colors
Type: `Object`
Default value: undefined

A map of colors that will be used to generate color variants for .svg files

## Running Specs

* clone this repo
* `npm install`
* `grunt spec`

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## License

MIT
