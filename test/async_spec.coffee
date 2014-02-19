Injector  = require('injector')

class Deferred

class EventuallyLoad
  promise: ->
    d = new Deferred()
    setTimeout(=>
      @mjNumber= 23
      d.resolve(this)
    , 100)
    d

describe 'An async injection', ->
  it 'should load after the deferred has been resolved', (done) ->
    done()
    # injector = new Injector()

    # injector.promise(EventuallyLoad).done ->
    #   expect(el.mjNumber).to.equal 23
    #   done()
