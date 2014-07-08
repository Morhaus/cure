expect = require 'expect.js'
Schema = require '../src/schema'
Promise = require 'bluebird'

describe 'Schema', ->
  describe '.define()', ->
    it 'should register an define', ->
      Schema.define 'in', (value, [array, err], callback) ->
        if (array.indexOf value) isnt -1
          callback null, value
        else
          callback (err or 'in'), value

      expect(Schema.prototype.in).to.be.a 'function'

    it 'should switch schema type', ->
      Schema.define 'join', Schema.String, (value, args, callback) ->
        callback null, (value.join args...)

      expect(Schema.prototype.join).to.be.a 'function'
      expect(new Schema().join()).to.be.a Schema.String

  describe '#run()', ->
    it 'should run validation actions', ->
      new Schema().in ['car', 'boat', 'plane']
        .run 'car', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'car'

        .run 'kitty', (err, value) ->
          expect(err.message).to.be 'in'
          expect(value).to.eql undefined

    it 'should run sanitization actions', ->
      Schema.define 'uppercase', (value, callback) ->
        callback null, value.toUpperCase()

      new Schema().uppercase()
        .run 'kitty', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'KITTY'

    it 'should run validation and sanitization actions', ->
      new Schema().uppercase().in ['cat', 'kitten', 'KITTY']
        .run 'kitty', (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql 'KITTY'

      new Schema().in(['car', 'boat', 'plane']).uppercase()
        .run 'CAR', (err, value) ->
          expect(err.message).to.be 'in'
          expect(value).to.eql undefined

    it 'should throw an error when the initial value is absent', ->
      new Schema()
        .run null, (err, value) ->
          expect(err.message).to.be 'required'
          expect(value).to.eql undefined

    it 'should return a Promise when the callback parameter is absent', ->
      sc = new Schema().in(['1', '2'])
      
      sc.run null
        .catch (err) ->
          expect(err.message).to.be 'required'
          return
        .then ->
          sc.run '2'
        .then (value) ->
          expect(value).to.be '2'
          return

  describe '#optional()', ->
    it 'should skip subsequent actions when the initial value is absent', ->
      new Schema().optional().in ['what']
        .run undefined, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql undefined

        .run null, (err, value) ->
          expect(err).to.eql null
          expect(value).to.eql undefined

  describe '#default()', ->
    it 'should default the value to the specified value', ->
      new Schema().default 0
        .run undefined, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 0

        .run null, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 0

        .run false, (err, value) ->
          expect(err).to.be undefined
          expect(value).to.be false

        .run '', (err, value) ->
          expect(err).to.be undefined
          expect(value).to.be ''

    it 'should skip subsequent actions', ->
      new Schema().default('lalala').uppercase()
        .run undefined, (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'lalala'

        .run 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'CAT'
