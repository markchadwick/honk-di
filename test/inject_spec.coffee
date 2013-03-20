expect = require('chai').expect

Injector  = require('injector')
inject    = require('inject')


describe 'Inject', ->
  describe 'a simple relation', ->
    beforeEach ->

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
    expect(sitter.cat.lies).to.not.exist

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
