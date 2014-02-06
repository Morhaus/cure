expect = require 'expect.js'
cure = require '../src'

describe 'DateSchema', ->
  describe '#before()', ->
    it 'should test the value against a minimal date', ->
      cure.date.before new Date(2014, 2, 5)
        .validate new Date(2014, 2, 4), (err, value) ->
          expect(err).to.be null
          expect(value).to.eql new Date(2014, 2, 4)

        .validate new Date(2014, 2, 5), (err, value) ->
          expect(err).to.be 'before'
          expect(value).to.eql new Date(2014, 2, 5)

        .validate new Date(2014, 2, 6), (err, value) ->
          expect(err).to.be 'before'
          expect(value).to.eql new Date(2014, 2, 6)

  describe '#after()', ->
    it 'should test the value against a maximal date', ->
      cure.date.after new Date(2014, 2, 5)
        .validate new Date(2014, 2, 4), (err, value) ->
          expect(err).to.be 'after'
          expect(value).to.eql new Date(2014, 2, 4)

        .validate new Date(2014, 2, 5), (err, value) ->
          expect(err).to.be 'after'
          expect(value).to.eql new Date(2014, 2, 5)

        .validate new Date(2014, 2, 6), (err, value) ->
          expect(err).to.be null
          expect(value).to.eql new Date(2014, 2, 6)

  describe '#equals()', ->
    it 'should test the value against a set date', ->
      cure.date.equals new Date(2014, 2, 5)
        .validate new Date(2014, 2, 4), (err, value) ->
          expect(err).to.be 'equals'
          expect(value).to.eql new Date(2014, 2, 4)

        .validate new Date(2014, 2, 5), (err, value) ->
          expect(err).to.be null
          expect(value).to.eql new Date(2014, 2, 5)

        .validate new Date(2014, 2, 6), (err, value) ->
          expect(err).to.be 'equals'
          expect(value).to.eql new Date(2014, 2, 6)
