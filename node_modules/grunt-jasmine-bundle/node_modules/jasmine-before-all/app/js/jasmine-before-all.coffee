((jasmine) ->
  root = this

  root.beforeAll = (doBeforeAll) ->
    itsBeenDoneBefore = false
    jasmine.getEnv().beforeEach doneWrapperFor doBeforeAll, (done) ->
      if itsBeenDoneBefore
        done() if typeof done == "function"
      else
        doBeforeAll.call(jasmine.getEnv().currentSpec, done)
        itsBeenDoneBefore = true

  doneWrapperFor = (func, toWrap) ->
    if func.length == 0
      -> toWrap()
    else
      (done) -> toWrap(done)

)(jasmine)
