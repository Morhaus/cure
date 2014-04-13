expect = require 'expect.js'
cure = require '../src'

describe 'NumberSchema', ->
  describe '#min()', ->
    it 'should test the value against a minimal value', ->
      cure.number.min 6
        .exec 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .exec 5, (err, value) ->
          expect(err).to.be 'min'
          expect(value).to.be 5

        .exec 7, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 7

  describe '#max()', ->
    it 'should test the value against a maximal value', ->
      cure.number.max 6
        .exec 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .exec 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .exec 7, (err, value) ->
          expect(err).to.be 'max'
          expect(value).to.be 7

  describe '#int()', ->
    it 'should test if the value is an integer', ->
      cure.number.int()
        .exec 10, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 10

        .exec 42, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 42

        .exec 7.6, (err, value) ->
          expect(err).to.be 'int'
          expect(value).to.be 7.6

        .exec 7.0, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 7.0
