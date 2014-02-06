expect = require 'expect.js'
cure = require '../src'

describe 'AnySchema', ->
  describe '#cast()', ->
    it 'should cast the value to the specified type', ->
      cure.any.cast Number
        .validate '5', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .validate '5.65', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5.65

  describe '#toJSON()', ->
    it 'should format the value to JSON', ->
      cure.any.toJSON()
        .validate 'test', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '"test"'

        .validate { toast: 'test' }, (err, value) ->
          expect(err).to.be null
          expect(value).to.be '{"toast":"test"}'

  describe '#in()', ->
    it 'should test if the value is in the supplied array', ->
      cure.any.in ['toast', 'test', 'pony']
        .validate 'toast', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'toast'

        .validate 'kitty cat', (err, value) ->
          expect(err).to.be 'in'
          expect(value).to.be 'kitty cat'

  describe '#strictIn()', ->
    it 'should test if the value is in the supplied array via an identity check', ->
      kitty = new Object
      toast = new Object
      pony = new Object
      test = new Object

      cure.any.strictIn [kitty, toast, pony]
        .validate toast, (err, value) ->
          expect(err).to.be null
          expect(value).to.be toast

        .validate test, (err, value) ->
          expect(err).to.be 'strictIn'
          expect(value).to.be test

  describe '#equals()', ->
    it 'should test if the value corresponds to the supplied value', ->
      cure.any.equals 4
        .validate 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .validate 5, (err, value) ->
          expect(err).to.be 'equals'
          expect(value).to.be 5

  describe '#strictEquals()', ->
    it 'should test if the value corresponds to the supplied value via an identity check', ->
      kitty = new Object
      toast = new Object

      cure.any.strictEquals kitty
        .validate kitty, (err, value) ->
          expect(err).to.be null
          expect(value).to.be kitty

        .validate toast, (err, value) ->
          expect(err).to.be 'strictEquals'
          expect(value).to.be toast

  describe '#empty()', ->
    it 'should test if the value is empty', ->
      cure.any.empty()
        .validate '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ''

        .validate [], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql []

        .validate {}, (err, value) ->
          expect(err).to.be null
          expect(value).to.eql {}

        .validate 'hello', (err, value) ->
          expect(err).to.be 'empty'
          expect(value).to.be 'hello'

        .validate ['hello'], (err, value) ->
          expect(err).to.be 'empty'
          expect(value).to.eql ['hello']

        .validate { hello: 'there' }, (err, value) ->
          expect(err).to.be 'empty'
          expect(value).to.eql { hello: 'there' }

  describe '#type()', ->
    it 'should test the type of the value against a given type', ->
      cure.any.type String
        .validate '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ''

        .validate [], (err, value) ->
          expect(err).to.be 'type'
          expect(value).to.eql []

      cure.any.type Array
        .validate '', (err, value) ->
          expect(err).to.be 'type'
          expect(value).to.be ''

        .validate [], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql []

  describe '#gt()', ->
    it 'should check if the value is greater than a given value', ->
      cure.any.gt 5
        .validate '4', (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be '4'

        .validate 4, (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 4

        .validate 5, (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 5

        .validate 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .validate '6', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '6'

      cure.any.gt 'e'
        .validate 'a', (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 'a'

        .validate 'e', (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 'e'

        .validate 'g', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'g'

  describe '#gte()', ->
    it 'should check if the value is greater than or equal to a given value', ->
      cure.any.gte 5
        .validate '4', (err, value) ->
          expect(err).to.be 'gte'
          expect(value).to.be '4'

        .validate 4, (err, value) ->
          expect(err).to.be 'gte'
          expect(value).to.be 4

        .validate 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .validate 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .validate '6', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '6'

      cure.any.gte 'e'
        .validate 'a', (err, value) ->
          expect(err).to.be 'gte'
          expect(value).to.be 'a'

        .validate 'e', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'e'

        .validate 'g', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'g'

  describe '#lt()', ->
    it 'should check if the value is less than a given value', ->
      cure.any.lt 5
        .validate '4', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '4'

        .validate 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .validate 5, (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 5

        .validate 6, (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 6

        .validate '6', (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be '6'

      cure.any.lt 'e'
        .validate 'a', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'a'

        .validate 'e', (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 'e'

        .validate 'g', (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 'g'

  describe '#lte()', ->
    it 'should check if the value is less than a given value', ->
      cure.any.lte 5
        .validate '4', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '4'

        .validate 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .validate 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .validate 6, (err, value) ->
          expect(err).to.be 'lte'
          expect(value).to.be 6

        .validate '6', (err, value) ->
          expect(err).to.be 'lte'
          expect(value).to.be '6'

      cure.any.lte 'e'
        .validate 'a', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'a'

        .validate 'e', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'e'

        .validate 'g', (err, value) ->
          expect(err).to.be 'lte'
          expect(value).to.be 'g'

  describe '#action()', ->
    it 'should execute an action on the value', ->
      cure.any.action -> @next ['hello', @value]
        .validate 'you', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'you']

      cure.any.action -> if @value is 'cat' then (@next "kitty #{@value}") else (@fail 'sad face :(')
        .validate 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'kitty cat'

        .validate 'pony', (err, value) ->
          expect(err).to.be 'sad face :('
          expect(value).to.be 'pony'
