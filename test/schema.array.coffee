expect = require 'expect.js'
cure = require '../src'

describe 'ArraySchema', ->
  describe '#slice()', ->
    it 'should slice the array', ->
      cure.array.slice 1, 3
        .exec [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [2, 3]

  describe '#includes()', ->
    it 'should test if the array includes a value', ->
      cure.array.includes 'cat'
        .exec ['dragon', 'dog', 'cat'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dragon', 'dog', 'cat']

        .exec ['dog', 'lizard'], (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.eql ['dog', 'lizard']

    it 'should test if the array includes multiple values', ->
      cure.array.includes ['cat', 'dog']
        .exec ['dog', 'cat', 'cameleon'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dog', 'cat', 'cameleon']

        .exec ['dog', 'lizard', 'cat'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dog', 'lizard', 'cat']

        .exec ['dog', 'lizard', 'dragon'], (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.eql ['dog', 'lizard', 'dragon']

  describe '#excludes()', ->
    it 'should test if the array excludes a value', ->
      cure.array.excludes 'cat'
        .exec ['dragon', 'dog', 'cat'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dragon', 'dog', 'cat']

        .exec ['dog', 'lizard'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['dog', 'lizard']

    it 'should test if the array excludes multiple values', ->
      cure.array.excludes ['cat', 'dog']
        .exec ['dog', 'cat', 'cameleon'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dog', 'cat', 'cameleon']

        .exec ['dog', 'lizard', 'cat'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dog', 'lizard', 'cat']

        .exec ['dog', 'lizard', 'dragon'], (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.eql ['dog', 'lizard', 'dragon']

        .exec ['pony', 'lizard', 'dragon'], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['pony', 'lizard', 'dragon']

  describe '#minLen()', ->
    it 'should test the length of the array against a minimal length', ->
      cure.array.minLen 4
        .exec [1, 2, 3], (err, value) ->
          expect(err).to.be 'minLen'
          expect(value).to.eql [1, 2, 3]

        .exec [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4]

        .exec [1, 2, 3, 4, 5], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4, 5]

  describe '#maxLen()', ->
    it 'should test the length of the array against a maximal length', ->
      cure.array.maxLen 4
        .exec [1, 2, 3], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3]

        .exec [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4]

        .exec [1, 2, 3, 4, 5], (err, value) ->
          expect(err).to.be 'maxLen'
          expect(value).to.eql [1, 2, 3, 4, 5]

  describe '#len()', ->
    it 'should test the length of the array against a given length', ->
      cure.array.len 4
        .exec [1, 2, 3], (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.eql [1, 2, 3]

        .exec [1, 2, 3, 4], (err, value) ->
          expect(err).to.be null
          expect(value).to.eql [1, 2, 3, 4]

        .exec [1, 2, 3, 4, 5], (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.eql [1, 2, 3, 4, 5]
