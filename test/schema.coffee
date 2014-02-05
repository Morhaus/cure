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
        .validate 'car', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'car'

        .validate 'kitty', (err, value) ->
          expect(err).to.eql 'in'
          expect(value).to.eql 'kitty'

    it 'should execute sanitization actions', ->
      Schema.action 'uppercase', -> @next @value.toUpperCase()

      new Schema().uppercase()
        .validate 'kitty', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'KITTY'

    it 'should execute validation and sanitization actions', ->
      new Schema().uppercase().in ['cat', 'kitten', 'KITTY']
        .validate 'kitty', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'KITTY'

      new Schema().in(['car', 'boat', 'plane']).uppercase()
        .validate 'CAR', (err, value) ->
          expect(err).to.eql 'in'
          expect(value).to.eql 'CAR'

  describe '#present()', ->
    it 'should throw an error when passed undefined or null', ->
      new Schema().present()
        .validate undefined, (err, value) ->
          expect(err).to.eql 'present'
          expect(value).to.eql undefined

        .validate null, (err, value) ->
          expect(err).to.eql 'present'
          expect(value).to.eql null

  describe '#not', ->
    it 'should reverse the next action', ->
      # Present/not present is a special case
      new Schema().not.present()
        .validate 1, (err, value) ->
          expect(err).to.eql 'not present'
          expect(value).to.eql 1

      new Schema().not.in ['car', 'boat', 'plane']
        .validate 'car', (err, value) ->
          expect(err).to.eql 'not in'
          expect(value).to.eql 'car'

