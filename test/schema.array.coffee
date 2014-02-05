expect = require 'expect.js'
ts = require '../src'

describe 'ArraySchema', ->
  describe '#slice()', ->
    it 'should slice the array', ->
      ts.array.slice 1, 3
        .validate [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [2, 3]

  describe '#includes()', ->
    it 'should test if the array includes a value', ->
      ts.array.includes 'cat'
        .validate ['dragon', 'dog', 'cat'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dragon', 'dog', 'cat']

        .validate ['dog', 'lizard'], (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.eql ['dog', 'lizard']

    it 'should test if the array includes multiple values', ->
      ts.array.includes 'cat', 'dog'
        .validate ['dog', 'cat', 'cameleon'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dog', 'cat', 'cameleon']

        .validate ['dog', 'lizard', 'cat'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dog', 'lizard', 'cat']

        .validate ['dog', 'lizard', 'dragon'], (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.eql ['dog', 'lizard', 'dragon']

  describe '#excludes()', ->
    it 'should test if the array excludes a value', ->
      ts.array.excludes 'cat'
        .validate ['dragon', 'dog', 'cat'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dragon', 'dog', 'cat']

        .validate ['dog', 'lizard'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dog', 'lizard']

    it 'should test if the array excludes multiple values', ->
      ts.array.excludes 'cat', 'dog'
        .validate ['dog', 'cat', 'cameleon'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dog', 'cat', 'cameleon']

        .validate ['dog', 'lizard', 'cat'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dog', 'lizard', 'cat']

        .validate ['dog', 'lizard', 'dragon'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dog', 'lizard', 'dragon']

        .validate ['pony', 'lizard', 'dragon'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['pony', 'lizard', 'dragon']

  describe '#minLen()', ->
    it 'should test the length of the array against a minimal length', ->
      ts.array.minLen 4
        .validate [1, 2, 3], (err, value) ->
          expect(err).to.be 'minLen'
          expect(value).to.eql [1, 2, 3]

        .validate [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4]

        .validate [1, 2, 3, 4, 5], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4, 5]

  describe '#maxLen()', ->
    it 'should test the length of the array against a maximal length', ->
      ts.array.maxLen 4
        .validate [1, 2, 3], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3]

        .validate [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4]

        .validate [1, 2, 3, 4, 5], (err, value) ->
          expect(err).to.be 'maxLen'
          expect(value).to.eql [1, 2, 3, 4, 5]

  describe '#len()', ->
    it 'should test the length of the array against a given length', ->
      ts.array.len 4
        .validate [1, 2, 3], (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.eql [1, 2, 3]

        .validate [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4]

        .validate [1, 2, 3, 4, 5], (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.eql [1, 2, 3, 4, 5]
