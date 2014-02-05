expect = require 'expect.js'
ts = require '../src'

describe 'ObjectSchema', ->
  describe '#format()', ->
    it 'should validate sub-properties', ->
      ts.object.format { cat: ts.string.minLen 4 }
        .validate { cat: 'kitty' }, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql { cat: 'kitty' }

        .validate { cat: 'CAT' }, (err, value) ->
          expect(err).to.eql [ { path: [ 'cat' ], error: 'minLen', type: 'StringSchema' } ]
          expect(value).to.eql { cat: 'CAT' }
