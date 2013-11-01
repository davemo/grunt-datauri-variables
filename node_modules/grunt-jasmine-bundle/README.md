# grunt-jasmine-bundle

[![Build Status](https://travis-ci.org/testdouble/grunt-jasmine-bundle.png)](https://travis-ci.org/testdouble/grunt-jasmine-bundle)

An opinionated little grunt task for running Jasmine specs of JavaScript/CoffeeScript written to run under Node.js.

It delegates to [minijasminenode](https://github.com/juliemr/minijasminenode) and includes the following goodies without you even asking:

* [jasmine-given](https://github.com/searls/jasmine-given)
* [jasmine-stealth](https://github.com/searls/jasmine-stealth)
* [jasmine-only](https://github.com/davemo/jasmine-only)
* [jasmine-before-all](https://github.com/testdouble/jasmine-before-all)
* [CoffeeScript](http://coffeescript.org)

## Usage

Check out [the included example project](https://github.com/testdouble/grunt-jasmine-bundle/tree/master/example) for a minimal realistic usage.


## Options

* **helpers** - a path, glob string, or array of paths and glob strings to all of your spec helpers in the build. These will be loaded prior to your specs (default is `"spec/helpers/**/*.{js,coffee}"`).
* **specs** - a path, glob string, or array of paths and glob strings to all of your specs themselves (default is `"spec/**/*.{js,coffee}"`).
* **minijasminenode** - a configuration object that will be passed to [minijasminenode](https://github.com/juliemr/minijasminenode#usage) in accordance to whatever options it accepts.

No configuration is necessary if the defaults work for you. A simple config might be as small as this, however:

```
grunt.initConfig({
  spec: {
    all: {
      minijasminenode: {
        showColors: true
      }
    }
  }
});
```

## Multiple builds

`grunt-jasmine-bundle` is a multi-task, which means that, if you choose, you can set up multiple builds via configuration. Something like this ought to work:

``` javascript
grunt.initConfig({
  spec: {
    options: {
      minijasminenode: {
        showColors: true
      }
    },
    unit: {
      helpers: ["shared/helpers/**/*.{js,coffee}", "test/helpers/**/*.{js,coffee}"],
      specs: "test/**/*.{js,coffee}"
    },
    e2e: {
      helpers: ["shared/helpers/**/*.{js,coffee}", "e2e/helpers/**/*.{js,coffee}"],
      specs: "e2e/**/*.{js,coffee}"
    }
  }
});
```
