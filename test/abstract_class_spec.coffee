expect    = require('chai').expect

inject    = require('inject')
Binder    = require('binder')
Injector  = require('injector')

mapInits = 0
funMapInits = 0

class Map
  @scope: 'SINGLETON'
  createMap: -> throw Error('Abstract method createMap')
  init: -> @map = @createMap()
  constructor: ->
    mapInits += 1
    throw Error('One can never be too safe')

class FunMap extends Map
  @inits = 0
  createMap: -> return 'Fun!'
  constructor: ->
    # Don't call super!
    funMapInits += 1

class App
  map: inject(Map)

class AppBinder extends Binder
  configure: ->
    @bind(Map).to(FunMap)

    # There is a bug when there are multiple bindings it can screw up
    # implementations are resolved during a single injection cycle. This binding
    # does nothing other that expose the bug.
    @bindConstant('unrelated').to(666)


describe 'Abstract classes', ->
  beforeEach ->
    @binder   = new AppBinder()
    @injector = new Injector(@binder)

  afterEach ->
    mapInits = 0
    funMapInits = 0

  it 'should have classes in a default state', ->
    expect(mapInits).to.equal 0
    expect(funMapInits).to.equal 0

  it 'should obey FunMap not calling super', ->
    new FunMap()
    expect(mapInits).to.equal 0
    expect(funMapInits).to.equal 1

  it 'should only create the required impls', ->
    @injector.getInstance(FunMap)
    expect(mapInits).to.equal 0
    expect(funMapInits).to.equal 1

    @injector.getInstance(Map)
    expect(mapInits).to.equal 0
    expect(funMapInits).to.equal 1

  it 'should only create bound impls via two steps', ->
    @injector.getInstance(App)
    expect(mapInits).to.equal 0
    expect(funMapInits).to.equal 1
