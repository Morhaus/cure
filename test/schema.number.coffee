expect = require 'expect.js'
cure = require '../src'

describe 'NumberSchema', ->
  describe '#min()', ->
    it 'should test the value against a minimal value', ->
      cure.number.min 6
        .validate 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .validate 5, (err, value) ->
          expect(err).to.be 'min'
          expect(value).to.be 5

        .validate 7, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 7

  describe '#max()', ->
    it 'should test the value against a maximal value', ->
      cure.number.max 6
        .validate 6, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 6

        .validate 5, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 5

        .validate 7, (err, value) ->
          expect(err).to.be 'max'
          expect(value).to.be 7

  describe '#int()', ->
    it 'should test if the value is an integer', ->
      cure.number.int()
        .validate 10, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 10

        .validate 42, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 42

        .validate 7.6, (err, value) ->
          expect(err).to.be 'int'
          expect(value).to.be 7.6

        .validate 7.0, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 7.0
