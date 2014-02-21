expect = require('chai').expect

ClassMap       = require('../lib/class_map')
TestSingleton2 = require('./test_singleton')

class TestSingleton
  @scope: 'SINGLETON'
  name:   'Test Singleton'


describe 'Class Map', ->
  it 'should get and set a class', ->
    cm  = new ClassMap()
    ts1 = new TestSingleton()
    ts2 = new TestSingleton2()

    expect(cm.get(TestSingleton)).to.not.exist
    expect(cm.get(TestSingleton2)).to.not.exist

    cm.set(TestSingleton, ts1)
    cm.set(TestSingleton2, ts2)

    expect(cm.get(TestSingleton)).to.equal ts1
    expect(cm.get(TestSingleton2)).to.equal ts2

  it 'should over-write a vlue', ->
    cm  = new ClassMap()
    ts1 = new TestSingleton()
    ts2 = new TestSingleton()

    cm.set(TestSingleton, ts1)
    expect(cm.get(TestSingleton)).to.equal ts1
    cm.set(TestSingleton, ts2)
    expect(cm.get(TestSingleton)).to.equal ts2

  it 'should not conflict with another ClassMap', ->
    class ClassA
      name: 'class a'

    class ClassB
      name: 'class b'

    cm1 = new ClassMap()
    cm2 = new ClassMap()
    a = new ClassA()
    b = new ClassB()

    cm1.set(ClassA, a)
    cm1.set(ClassB, b)

    expect(cm1.get(ClassA)).to.equal a
    expect(cm1.get(ClassB)).to.equal b
    expect(cm2.get(ClassA)).to.not.exist
    expect(cm2.get(ClassB)).to.not.expect

    cm2.set(ClassB, b)
    cm2.set(ClassA, a)
    expect(cm1.get(ClassA)).to.equal a
    expect(cm1.get(ClassB)).to.equal b
    expect(cm2.get(ClassA)).to.equal a
    expect(cm2.get(ClassB)).to.equal b
