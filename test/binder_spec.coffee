expect = require('chai').expect

Binder = require('../lib/binder')


class Parent
  name: 'Parent'

class Child1 extends Parent
  name: 'Child1'

class Child2 extends Parent
  name: 'Child2'

class GrandChild extends Child1
  name: 'GrandChild'

class Singleton
  @scope:  'SINGLETON'

class InvalidScope
  @scope:  'Entirely Invalid'


describe 'A binder', ->

  it 'should create bindings', ->
    class MyBinder extends Binder
      configure: ->
        @bind(Parent).to(Child1)
        @bind(Child1).to(GrandChild)

    binder = new MyBinder()
    expect(binder.bindings).to.have.length 2

  it 'should throw an exception when re-binding', ->
    class Rebinder extends Binder
      configure: ->
        @bind(Parent).to(Child1).to(Child2)
    create = -> new Rebinder()
    expect(create).to.throw /Already bound/

  it 'should bind a class in a scope', ->
    class Scoped extends Binder
      configure: ->
        @bind(Child1).inScope('singleton')

    binding = new Scoped().bindings[0]
    expect(binding.iface).to.equal Child1
    expect(binding.scope).to.equal 'SINGLETON'

  it 'should throw an error when binding to an invalid scope', ->
    class InvalidScoped extends Binder
      configure: ->
        @bind(Parent).inScope('pant suit')
    create = -> new InvalidScoped()
    expect(create).to.throw /Invalid scope, 'pant suit'/

  it 'should not bind an instance with invalid scope', ->
    class BadScope extends Binder
      configure: ->
        @bind(InvalidScope)
    expect(InvalidScope.scope).to.equal 'Entirely Invalid'
    create = -> new BadScope()
    expect(create).to.throw /Invalid scope, 'Entirely Invalid'/

  it 'should throw an error when scoping something with a scope', ->
    class Rescoper extends Binder
      configure: ->
        @bind(Singleton).inScope('INSTANCE')
    create = -> new Rescoper()
    expect(create).to.throw /Already scoped to SINGLETON/

  it 'should bind a constant', ->
    class ConstantBinder extends Binder
      configure: ->
        @bindConstant('frank.age').to(22)

    binder = new ConstantBinder()
    expect(binder.bindings).to.have.length 1

  it 'should resolve match based on matching __honk_clsid', ->
    class Class3
      name: 'Class 3'

    class Class1
      @__honk_clsid: 'this is class one'

    class Class2
      @__honk_clsid: 'this is class one'

    class TestClassEqualityBinder extends Binder
      configure: ->
        @bind(Class1).to(Class3)

    binder = new TestClassEqualityBinder(Class3)
    expect(binder.bindings).to.have.length 1
    matched = binder.bindings[0].matches(Class2)
    expect(matched).to.be.true
