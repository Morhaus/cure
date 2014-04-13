expect = require 'expect.js'
cure = require '../src'

describe 'AnySchema', ->
  describe '#cast()', ->
    it 'should cast the value to the specified type', ->
      cure.any.cast Number
        .exec '5', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .exec '5.65', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5.65

  describe '#toJSON()', ->
    it 'should format the value to JSON', ->
      cure.any.toJSON()
        .exec 'test', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '"test"'

        .exec { toast: 'test' }, (err, value) ->
          expect(err).to.be null
          expect(value).to.be '{"toast":"test"}'

  describe '#in()', ->
    it 'should test if the value is in the supplied array', ->
      cure.any.in ['toast', 'test', 'pony']
        .exec 'toast', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'toast'

        .exec 'kitty cat', (err, value) ->
          expect(err).to.be 'in'
          expect(value).to.be 'kitty cat'

  describe '#strictIn()', ->
    it 'should test if the value is in the supplied array via an identity check', ->
      kitty = new Object
      toast = new Object
      pony = new Object
      test = new Object

      cure.any.strictIn [kitty, toast, pony]
        .exec toast, (err, value) ->
          expect(err).to.be null
          expect(value).to.be toast

        .exec test, (err, value) ->
          expect(err).to.be 'strictIn'
          expect(value).to.be test

  describe '#equals()', ->
    it 'should test if the value corresponds to the supplied value', ->
      cure.any.equals 4
        .exec 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .exec 5, (err, value) ->
          expect(err).to.be 'equals'
          expect(value).to.be 5

  describe '#strictEquals()', ->
    it 'should test if the value corresponds to the supplied value via an identity check', ->
      kitty = new Object
      toast = new Object

      cure.any.strictEquals kitty
        .exec kitty, (err, value) ->
          expect(err).to.be null
          expect(value).to.be kitty

        .exec toast, (err, value) ->
          expect(err).to.be 'strictEquals'
          expect(value).to.be toast

  describe '#empty()', ->
    it 'should test if the value is empty', ->
      cure.any.empty()
        .exec '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ''

        .exec [], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql []

        .exec {}, (err, value) ->
          expect(err).to.be null
          expect(value).to.eql {}

        .exec 'hello', (err, value) ->
          expect(err).to.be 'empty'
          expect(value).to.be 'hello'

        .exec ['hello'], (err, value) ->
          expect(err).to.be 'empty'
          expect(value).to.eql ['hello']

        .exec { hello: 'there' }, (err, value) ->
          expect(err).to.be 'empty'
          expect(value).to.eql { hello: 'there' }

  describe '#type()', ->
    it 'should test the type of the value against a given type', ->
      cure.any.type String
        .exec '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ''

        .exec [], (err, value) ->
          expect(err).to.be 'type'
          expect(value).to.eql []

      cure.any.type Array
        .exec '', (err, value) ->
          expect(err).to.be 'type'
          expect(value).to.be ''

        .exec [], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql []

  describe '#gt()', ->
    it 'should check if the value is greater than a given value', ->
      cure.any.gt 5
        .exec '4', (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be '4'

        .exec 4, (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 4

        .exec 5, (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 5

        .exec 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .exec '6', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '6'

      cure.any.gt 'e'
        .exec 'a', (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 'a'

        .exec 'e', (err, value) ->
          expect(err).to.be 'gt'
          expect(value).to.be 'e'

        .exec 'g', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'g'

  describe '#gte()', ->
    it 'should check if the value is greater than or equal to a given value', ->
      cure.any.gte 5
        .exec '4', (err, value) ->
          expect(err).to.be 'gte'
          expect(value).to.be '4'

        .exec 4, (err, value) ->
          expect(err).to.be 'gte'
          expect(value).to.be 4

        .exec 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .exec 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .exec '6', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '6'

      cure.any.gte 'e'
        .exec 'a', (err, value) ->
          expect(err).to.be 'gte'
          expect(value).to.be 'a'

        .exec 'e', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'e'

        .exec 'g', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'g'

  describe '#lt()', ->
    it 'should check if the value is less than a given value', ->
      cure.any.lt 5
        .exec '4', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '4'

        .exec 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .exec 5, (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 5

        .exec 6, (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 6

        .exec '6', (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be '6'

      cure.any.lt 'e'
        .exec 'a', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'a'

        .exec 'e', (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 'e'

        .exec 'g', (err, value) ->
          expect(err).to.be 'lt'
          expect(value).to.be 'g'

  describe '#lte()', ->
    it 'should check if the value is less than a given value', ->
      cure.any.lte 5
        .exec '4', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '4'

        .exec 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .exec 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .exec 6, (err, value) ->
          expect(err).to.be 'lte'
          expect(value).to.be 6

        .exec '6', (err, value) ->
          expect(err).to.be 'lte'
          expect(value).to.be '6'

      cure.any.lte 'e'
        .exec 'a', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'a'

        .exec 'e', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'e'

        .exec 'g', (err, value) ->
          expect(err).to.be 'lte'
          expect(value).to.be 'g'

  describe '#action()', ->
    it 'should execute an action on the value', ->
      cure.any.action -> @next ['hello', @value]
        .exec 'you', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'you']

      cure.any.action -> if @value is 'cat' then (@next "kitty #{@value}") else (@fail 'sad face :(')
        .exec 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'kitty cat'

        .exec 'pony', (err, value) ->
          expect(err).to.be 'sad face :('
          expect(value).to.be 'pony'
