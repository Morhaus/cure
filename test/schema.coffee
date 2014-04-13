expect = require 'expect.js'
Schema = require '../src/schema'

describe 'Schema', ->
  describe '.action()', ->
    it 'should register an action', ->
      Schema.action 'in', (array) -> if (array.indexOf @value) isnt -1 then @next() else @fail()
      expect(Schema.prototype.in).to.be.a 'function'

    it 'should switch schema type', ->
      Schema.action 'join', Schema.String, -> @next (@value.join '')
      expect(Schema.prototype.join).to.be.a 'function'
      expect(new Schema().join()).to.be.a Schema.String

  describe '#validate()', ->
    it 'should execute validation actions', ->
      new Schema().in ['car', 'boat', 'plane']
        .exec 'car', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'car'

        .exec 'kitty', (err, value) ->
          expect(err).to.eql 'in'
          expect(value).to.eql 'kitty'

    it 'should execute sanitization actions', ->
      Schema.action 'uppercase', -> @next @value.toUpperCase()

      new Schema().uppercase()
        .exec 'kitty', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'KITTY'

    it 'should execute validation and sanitization actions', ->
      new Schema().uppercase().in ['cat', 'kitten', 'KITTY']
        .exec 'kitty', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'KITTY'

      new Schema().in(['car', 'boat', 'plane']).uppercase()
        .exec 'CAR', (err, value) ->
          expect(err).to.eql 'in'
          expect(value).to.eql 'CAR'

  describe '#present()', ->
    it 'should throw an error when passed undefined or null', ->
      new Schema().present()
        .exec undefined, (err, value) ->
          expect(err).to.eql 'present'
          expect(value).to.eql undefined

        .exec null, (err, value) ->
          expect(err).to.eql 'present'
          expect(value).to.eql null

    it 'should throw the specified error', ->
      new Schema().present('required')
        .exec undefined, (err, value) ->
          expect(err).to.eql 'required'
          expect(value).to.eql undefined

      new Schema().not.present('do not want')
        .exec 'hello', (err, value) ->
          expect(err).to.eql 'do not want'
          expect(value).to.eql 'hello'


  describe '#default()', ->
    it 'should default the value to the specified value', ->
      new Schema().default 0
        .exec undefined, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 0

        .exec null, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 0

        .exec false, (err, value) ->
          expect(err).to.be null
          expect(value).to.be false

        .exec '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ''

    it 'should not skip subsequent actions', ->
      new Schema().default('lalala').uppercase()
        .exec undefined, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'LALALA'

        .exec 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'CAT'

  describe '#not', ->
    it 'should reverse the next action', ->
      # Present/not present is a special case
      new Schema().not.present()
        .exec 1, (err, value) ->
          expect(err).to.eql 'not present'
          expect(value).to.eql 1

      new Schema().not.in ['car', 'boat', 'plane']
        .exec 'car', (err, value) ->
          expect(err).to.eql 'not in'
          expect(value).to.eql 'car'

