expect = require('chai').expect

Injector       = require('injector')
TestSingleton2 = require('./test_singleton')

class TestSingleton
  @scope: 'SINGLETON'
  name:   'Test Singleton'

describe 'Name conflicts', ->
  it 'should resolve independently', ->
    expect(TestSingleton.toString()).to.equal TestSingleton2.toString()
    i = new Injector()

    i1 = i.getInstance(TestSingleton)
    i2 = i.getInstance(TestSingleton2)

    expect(i1.name).to.equal 'Test Singleton'
    expect(i2.name).to.equal 'Test Singleton 2'
    expect(i1).to.be.an.instanceOf TestSingleton
    expect(i2).to.be.an.instanceOf TestSingleton2
