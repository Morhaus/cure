expect = require 'expect.js'
cure = require '../src'

describe 'ObjectSchema', ->
  describe '#format()', ->
    it 'should validate sub-properties', ->
      cure.object.format { cat: cure.string.minLen 4 }
        .validate { cat: 'kitty' }, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql { cat: 'kitty' }

        .validate { cat: 'CAT' }, (err, value) ->
          expect(err).to.eql [ { path: [ 'cat' ], error: 'minLen', type: 'StringSchema' } ]
          expect(value).to.eql { cat: 'CAT' }

    it 'should fill defaults of sub-properties when they do not exist', ->
      cure.object.format { cat: cure.string.default('kitty').minLen 4 }
        .validate {}, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql { cat: 'kitty' }

        .validate { cat: null }, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql { cat: 'kitty' }
