expect = require 'expect.js'
ts = require '../src'

describe 'StringSchema', ->
  describe '#split()', ->
    it 'should split the string according to a sub-string', ->
      ts.string.split ' '
        .validate 'hello there', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'there']

    it 'should split the string according to a regex', ->
      ts.string.split /\s+/
        .validate 'hello hello    hiiii', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'hello', 'hiiii']

  describe '#append()', ->
    it 'should append to the string', ->
      ts.string.append ' test'
        .validate 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'cat test'

        .validate '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ' test'

  describe '#prepend()', ->
    it 'should prepend to the string', ->
      ts.string.prepend 'i like '
        .validate 'cats', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like cats'

        .validate '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like '

  describe '#surround()', ->
    it 'should surround the string', ->
      ts.string.surround 'o'
        .validate '_', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'o_o'

        .validate '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'oo'

  describe '#trim()', ->
    it 'should trim the string', ->
      ts.string.trim()
        .validate '      hello    hello     ', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello    hello'

        .validate '  \t\n   hey\t', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hey'

  describe '#parseJSON()', ->
    it 'should parse JSON from the string', ->
      ts.string.parseJSON()
        .validate '{"state":"hello"}', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql { state: 'hello' }

  describe '#includes()', ->
    it 'should test for the inclusion of a sub-string', ->
      ts.string.includes 'cat'
        .validate 'i like cats', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like cats'

        .validate 'hello', (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.be 'hello'

    it 'should test for the inclusion of multiple sub-strings', ->
      ts.string.includes 'hello', 'there'
        .validate 'hello there', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello there'

        .validate 'hi there', (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.be 'hi there'

  describe '#minLen()', ->
    it 'should test the length of the string against a minimal length', ->
      ts.string.minLen 11
        .validate 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .validate 'hello worlds', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello worlds'

        .validate 'hello', (err, value) ->
          expect(err).to.be 'minLen'
          expect(value).to.be 'hello'

  describe '#maxLen()', ->
    it 'should test the length of the string against a maximal length', ->
      ts.string.maxLen 11
        .validate 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .validate 'hello worlds', (err, value) ->
          expect(err).to.be 'maxLen'
          expect(value).to.be 'hello worlds'

        .validate 'hello', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello'

  describe '#len()', ->
    it 'should test the length of the string against a certain length', ->
      ts.string.len 11
        .validate 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .validate 'hello worlds', (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.be 'hello worlds'

        .validate 'hello', (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.be 'hello'

  describe '#email()', ->
    it 'should test if the string is an email', ->
      ts.string.email()
        .validate 'hello@world.com', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello@world.com'

        .validate 'hello@world', (err, value) ->
          expect(err).to.be 'email'
          expect(value).to.be 'hello@world'

        .validate 'hello@world@world.com', (err, value) ->
          expect(err).to.be 'email'
          expect(value).to.be 'hello@world@world.com'

  describe '#match()', ->
    it 'should test if the string against a regex', ->
      # From http://net.tutsplus.com/tutorials/other/8-regular-expressions-you-should-know/
      ts.string.match /^[a-z0-9_-]{3,16}$/  
        .validate '-a', (err, value) ->
          expect(err).to.be 'match'
          expect(value).to.be '-a'

        .validate 'h3y', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'h3y'

        .validate 'azerty123456-_', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'azerty123456-_'

        .validate 'azerty123456-_qsdf', (err, value) ->
          expect(err).to.be 'match'
          expect(value).to.be 'azerty123456-_qsdf'
