if(!global.jasmine) {
  throw new Error("global.jasmine must exist before requiring jasmine-before-all. Ensure you require jasmine first.");
}
require('coffee-script')
require('./app/js/jasmine-before-all')
