expect = require 'expect.js'
cure = require '../src'

describe 'AnySchema', ->
  describe '#cast()', ->
    it 'should cast the value to the specified type', ->
      cure.any.cast Number
        .run '5', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .run '5.65', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5.65

  describe '#toJSON()', ->
    it 'should format the value to JSON', ->
      cure.any.toJSON()
        .run 'test', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '"test"'

        .run { toast: 'test' }, (err, value) ->
          expect(err).to.be null
          expect(value).to.be '{"toast":"test"}'

  describe '#in()', ->
    it 'should test if the value is in the supplied array', ->
      cure.any.in ['toast', 'test', 'pony']
        .run 'toast', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'toast'

        .run 'kitty cat', (err, value) ->
          expect(err.message).to.be 'in'
          expect(value).to.be undefined

  describe '#equals()', ->
    it 'should test if the value corresponds to the supplied value', ->
      cure.any.equals 4
        .run 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .run 5, (err, value) ->
          expect(err.message).to.be 'equals'
          expect(value).to.be undefined

  describe '#strictEquals()', ->
    it 'should test if the value corresponds to the supplied value via an identity check', ->
      kitty = new Object
      toast = new Object

      cure.any.strictEquals kitty
        .run kitty, (err, value) ->
          expect(err).to.be null
          expect(value).to.be kitty

        .run toast, (err, value) ->
          expect(err.message).to.be 'strictEquals'
          expect(value).to.be undefined

  describe '#empty()', ->
    it 'should test if the value is empty', ->
      cure.any.empty()
        .run '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ''

        .run [], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql []

        .run {}, (err, value) ->
          expect(err).to.be null
          expect(value).to.eql {}

        .run 'hello', (err, value) ->
          expect(err.message).to.be 'empty'
          expect(value).to.be undefined

        .run ['hello'], (err, value) ->
          expect(err.message).to.be 'empty'
          expect(value).to.be undefined

        .run { hello: 'there' }, (err, value) ->
          expect(err.message).to.be 'empty'
          expect(value).to.be undefined

  describe '#is()', ->
    it 'should test the type of the value against a given type', ->
      cure.any.is String
        .run '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ''

        .run [], (err, value) ->
          expect(err.message).to.be 'is'
          expect(value).to.be undefined

      cure.any.is Array
        .run '', (err, value) ->
          expect(err.message).to.be 'is'
          expect(value).to.be undefined

        .run [], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql []

  describe '#gt()', ->
    it 'should check if the value is greater than a given value', ->
      cure.any.gt 5
        .run '4', (err, value) ->
          expect(err.message).to.be 'gt'
          expect(value).to.be undefined

        .run 4, (err, value) ->
          expect(err.message).to.be 'gt'
          expect(value).to.be undefined

        .run 5, (err, value) ->
          expect(err.message).to.be 'gt'
          expect(value).to.be undefined

        .run 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .run '6', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '6'

      cure.any.gt 'e'
        .run 'a', (err, value) ->
          expect(err.message).to.be 'gt'
          expect(value).to.be undefined

        .run 'e', (err, value) ->
          expect(err.message).to.be 'gt'
          expect(value).to.be undefined

        .run 'g', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'g'

  describe '#gte()', ->
    it 'should check if the value is greater than or equal to a given value', ->
      cure.any.gte 5
        .run '4', (err, value) ->
          expect(err.message).to.be 'gte'
          expect(value).to.be undefined

        .run 4, (err, value) ->
          expect(err.message).to.be 'gte'
          expect(value).to.be undefined

        .run 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .run 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .run '6', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '6'

      cure.any.gte 'e'
        .run 'a', (err, value) ->
          expect(err.message).to.be 'gte'
          expect(value).to.be undefined

        .run 'e', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'e'

        .run 'g', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'g'

  describe '#lt()', ->
    it 'should check if the value is less than a given value', ->
      cure.any.lt 5
        .run '4', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '4'

        .run 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .run 5, (err, value) ->
          expect(err.message).to.be 'lt'
          expect(value).to.be undefined

        .run 6, (err, value) ->
          expect(err.message).to.be 'lt'
          expect(value).to.be undefined

        .run '6', (err, value) ->
          expect(err.message).to.be 'lt'
          expect(value).to.be undefined

      cure.any.lt 'e'
        .run 'a', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'a'

        .run 'e', (err, value) ->
          expect(err.message).to.be 'lt'
          expect(value).to.be undefined

        .run 'g', (err, value) ->
          expect(err.message).to.be 'lt'
          expect(value).to.be undefined

  describe '#lte()', ->
    it 'should check if the value is less than a given value', ->
      cure.any.lte 5
        .run '4', (err, value) ->
          expect(err).to.be null
          expect(value).to.be '4'

        .run 4, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 4

        .run 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .run 6, (err, value) ->
          expect(err.message).to.be 'lte'
          expect(value).to.be undefined

        .run '6', (err, value) ->
          expect(err.message).to.be 'lte'
          expect(value).to.be undefined

      cure.any.lte 'e'
        .run 'a', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'a'

        .run 'e', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'e'

        .run 'g', (err, value) ->
          expect(err.message).to.be 'lte'
          expect(value).to.be undefined

  describe '#action()', ->
    it 'should run an action on the value', ->
      cure.any.action (value, callback) -> callback null, ['hello', value]
        .run 'you', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'you']

      cure.any
        .action (value, callback) ->
          if value is 'cat'
            callback null, "kitty #{value}"
          else
            callback 'sad face :('
        .run 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'kitty cat'

        .run 'pony', (err, value) ->
          expect(err.message).to.be 'sad face :('
          expect(value).to.be undefined
