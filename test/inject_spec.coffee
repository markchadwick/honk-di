expect = require('chai').expect

Injector  = require('../lib/injector')
inject    = require('../lib/inject')

class SomeSingleton
  @scope: 'SINGLETON'
  constructor: ->
    @name = 'singleton!'


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

  it 'should resolve a parents injected fields', ->
    class Parent
      parentField:  inject(SomeSingleton)

    class Child extends Parent
      childField:   inject(SomeSingleton)

    injector  = new Injector()
    child     = injector.getInstance(Child)
    singleton = injector.getInstance(SomeSingleton)

    expect(child.parentField).to.equal singleton
    expect(child.parentField).to.equal singleton
    expect(child.childField).to.equal (child.parentField)

  it 'should have injected fields in place before the constructor is called', (done) ->
    class Constd
      buddy: inject(SomeSingleton)
      age: 23

      constructor: ->
        expect(@buddy).to.exist
        expect(@buddy._requiresInjection_).to.not.exist
        expect(@buddy.name).to.equal 'singleton!'
        expect(@age).to.equal 23
        done()

    new Injector().getInstance(Constd)

  describe 'attempting to inject undefined', ->
    it 'should give you a helpful error', ->
      create = ->
        class TryToInjectUndefined
          inject undefined

      expect(create).to.throw /Cannot inject undefined/

