expect = require('chai').expect

Injector  = require('injector')
inject    = require('inject')


describe 'Inject', ->
  it 'should inject requried fields', ->
    class MyCat
      constructor: (@likes) ->
        @name = 'Mittenslayer'

    class CatSitter
      cat:  inject(MyCat)
      age:  44

    injector = new Injector()
    sitter = injector.getInstance(CatSitter)
    expect(sitter.cat).to.exist
    expect(sitter.cat.name).to.equal 'Mittenslayer'
    expect(sitter.cat.likes).to.not.exist

  it 'should pass construction fields', ->
    class MyCat
      constructor: (@likes) ->
        @name = 'Mittenslayer'

    class CatSitter
      cat:  inject(MyCat, 'kibble')
      age:  44

    injector = new Injector()
    sitter = injector.getInstance(CatSitter)
    expect(sitter.cat.name).to.equal 'Mittenslayer'
    expect(sitter.cat.likes).to.equal 'kibble'

  it 'should not pass argument params to a singleton', ->
    class MyCat
      @scope: 'SINGLETON'
      constructor: (@likes) ->
        @name = 'Mittenslayer'

    injector = new Injector()
    create = ->
      class CatSitter
        cat:  inject(MyCat, 'kibble')
      injector.getInstance(CatSitter)
    expect(create).to.throw /Cannot assign arguments to a singleton/
