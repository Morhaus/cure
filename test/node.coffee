expect = require 'expect.js'
Node = require '../src/node'

describe 'Node', ->
  object = null
  node = null

  beforeEach ->
    object = 
      foo: 'bar'
      bar:
        foo: 1
        bar: 2
      foobar:
        foo:
          bar: 1
          foo: 2

    node = new Node
    node.setup object

  describe '#setup()', ->
    it 'should build a tree of nodes from an input object', ->
      expect(node.nodes.foo.value).to.eql 'bar'
      expect(node.nodes.bar.nodes.foo.value).to.eql 1
      expect(node.nodes.bar.nodes.bar.value).to.eql 2
      expect(node.nodes.foobar.nodes.foo.nodes.bar.value).to.eql 1
      expect(node.nodes.foobar.nodes.foo.nodes.foo.value).to.eql 2

  describe '#clear()', ->
    it 'should reset the value of the node', ->
      node.clear()
      expect(node).not.to.have.property 'nodes'
      expect(node).not.to.have.property 'value'

  describe '#resolve()', ->
    it 'should resolve an array of nodes from a path', ->
      result = node.resolve 'foo'
      expect(result).to.have.length 1
      expect(result[0]).to.eql node.nodes.foo

      result = node.resolve 'bar.foo'
      expect(result).to.have.length 1
      expect(result[0]).to.eql node.nodes.bar.nodes.foo

      result = node.resolve 'foobar.foo.bar'
      expect(result).to.have.length 1
      expect(result[0]).to.eql node.nodes.foobar.nodes.foo.nodes.bar

  describe '#make()', ->
    it 'should build a node tree from a path', ->
      node.make 'barfoo.bar.foo'
      expect(node.nodes).to.have.property 'barfoo'
      expect(node.nodes.barfoo.nodes).to.have.property 'bar'
      expect(node.nodes.barfoo.nodes.bar.nodes).to.have.property 'foo'

  describe '#build()', ->
    it 'should build a new object from a node tree', ->
      expect(node.build()).not.to.be object
      expect(node.build()).to.eql object

    it 'should not affect the source object', ->
      node.nodes.foo.value = 1
      expect(object.foo).to.eql 'bar'
      expect(node.build().foo).to.eql 1
