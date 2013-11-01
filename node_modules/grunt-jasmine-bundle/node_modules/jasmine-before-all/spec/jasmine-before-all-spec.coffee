describe 'jasmine-before-all', ->

  describe 'intentional pollution', ->
    foo = 0
    beforeAll -> foo += 1

    context '1', ->
      Then -> foo == 1

    context '2', ->
      Then -> foo == 1

    context '3', ->
      Then -> foo == 1

  xdescribe '(asynchronous) intentional pollution', ->
    async = new AsyncSpec(this)

    bar = 3
    async.beforeAll (done) ->
      setTimeout ->
        bar -= 1
        done()
      , 100

    context '1', ->
      Then -> bar == 2

    context '2', ->
      Then -> bar == 2

    context '3', ->
      Then -> bar == 2
