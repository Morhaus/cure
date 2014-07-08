expect = require 'expect.js'
cure = require '../src'

describe 'ObjectSchema', ->
  describe '#format()', ->
    it 'should validate sub-properties', ->
      cure.object.format cat: (cure.string.minLen 4)
        .run cat: 'kitty', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql cat: 'kitty'

        .run cat: 'CAT', (err, value) ->
          expect(err.errors[0].key).to.be 'cat'
          expect(err.errors[0].error.message).to.be 'minLen'
          expect(value).to.be undefined

    it 'should fill defaults of sub-properties when they do not exist', ->
      cure.object.format cat: (cure.string.default 'kitty')
        .run {}, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql cat: 'kitty'

        .run cat: null, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql cat: 'kitty'
