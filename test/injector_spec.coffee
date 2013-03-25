expect = require('chai').expect

Binder    = require('binder')
Injector  = require('injector')


class Parent
  name: 'Parent'

class Child1 extends Parent
  name: 'Child1'

class Child2 extends Parent
  name: 'Child2'

class GrandChild extends Child1
  name: 'GrandChild'

class MySingleton
  @scope: 'SINGLETON'

class MyParamed
  constructor: (@name, @age) ->

describe 'An injector', ->
  it 'should create an instance', ->
    injector = new Injector()

    instance = injector.getInstance(GrandChild)
    expect(instance.name).to.equal 'GrandChild'

    instance = injector.getInstance(Parent)
    expect(instance.name).to.equal 'Parent'

  it 'should bail when trying to create an unknown child', ->
    injector = new Injector()
    create = -> injector.getInstance(666)
    expect(create).to.throw /Could not resolve/

  it 'should return the same instance when creating a singleton', ->
    injector = new Injector()
    inst1 = injector.getInstance(MySingleton)
    inst2 = injector.getInstance(MySingleton)

    expect(inst1).to.equal inst2

  it 'should pass constructor args', ->
    injector = new Injector()

    unnamed = injector.getInstance(MyParamed)
    named   = injector.getInstance(MyParamed, 'Frank', 44)

    expect(unnamed.name).to.not.exist
    expect(unnamed.age).to.not.exist
    expect(named.name).to.equal 'Frank'
    expect(named.age).to.equal 44

  it 'should obey a simple singleton binding', ->
    class MyBinder extends Binder
      configure: ->
        @bind(Parent).to(Child2)

    injector = new Injector(new MyBinder())

    expect(injector.getInstance(Child2)).to.be.an.instanceOf Child2
    expect(injector.getInstance(Parent)).to.be.an.instanceOf Child2

  it 'should obey a simple instance binding', ->
    class MyBinder extends Binder
      configure: ->
        @bind(Child2).to(GrandChild).inScope('INSTANCE')

    injector = new Injector(new MyBinder())
    inst1 = injector.getInstance(Child2)
    inst2 = injector.getInstance(Child2)

    expect(inst1).to.be.an.instanceOf GrandChild
    expect(inst2).to.be.an.instanceOf GrandChild

    expect(inst1).to.not.equal inst2

  it 'should obey a simple constant binding', ->
    class MyBinder extends Binder
      configure: ->
        @bindConstant('pants').to(666)
    injector = new Injector(new MyBinder())
    expect(injector.getInstance('pants')).to.equal 666

  it 'should return itself when asking for an injector', ->
    injector = new Injector()
    injector.someNewField = 3
    expect(injector.getInstance(Injector).someNewField).to.equal 3
