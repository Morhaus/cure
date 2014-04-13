expect = require 'expect.js'
cure = require '../src'

describe 'StringSchema', ->
  describe '#split()', ->
    it 'should split the string according to a sub-string', ->
      cure.string.split ' '
        .exec 'hello there', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'there']

    it 'should split the string according to a regex', ->
      cure.string.split /\s+/
        .exec 'hello hello    hiiii', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'hello', 'hiiii']

  describe '#append()', ->
    it 'should append to the string', ->
      cure.string.append ' test'
        .exec 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'cat test'

        .exec '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ' test'

  describe '#prepend()', ->
    it 'should prepend to the string', ->
      cure.string.prepend 'i like '
        .exec 'cats', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like cats'

        .exec '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like '

  describe '#surround()', ->
    it 'should surround the string', ->
      cure.string.surround 'o'
        .exec '_', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'o_o'

        .exec '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'oo'

  describe '#trim()', ->
    it 'should trim the string', ->
      cure.string.trim()
        .exec '      hello    hello     ', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello    hello'

        .exec '  \t\n   hey\t', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hey'

  describe '#parseJSON()', ->
    it 'should parse JSON from the string', ->
      cure.string.parseJSON()
        .exec '{"state":"hello"}', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql { state: 'hello' }

  describe '#includes()', ->
    it 'should test for the inclusion of a sub-string', ->
      cure.string.includes 'cat'
        .exec 'i like cats', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like cats'

        .exec 'hello', (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.be 'hello'

    it 'should test for the inclusion of multiple sub-strings', ->
      cure.string.includes ['hello', 'there']
        .exec 'hello there', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello there'

        .exec 'hi there', (err, value) ->
          expect(err).to.be 'includes'
          expect(value).to.be 'hi there'

  describe '#excludes()', ->
    it 'should test for the exclusion of a sub-string', ->
      cure.string.excludes 'cat'
        .exec 'i like cats', (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.be 'i like cats'

        .exec 'hello', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello'

    it 'should test for the exclusion of multiple sub-strings', ->
      cure.string.excludes ['hello', 'there']
        .exec 'what there', (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.be 'what there'

        .exec 'hi you', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hi you'

        .exec 'hi hello', (err, value) ->
          expect(err).to.be 'excludes'
          expect(value).to.be 'hi hello'

  describe '#minLen()', ->
    it 'should test the length of the string against a minimal length', ->
      cure.string.minLen 11
        .exec 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .exec 'hello worlds', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello worlds'

        .exec 'hello', (err, value) ->
          expect(err).to.be 'minLen'
          expect(value).to.be 'hello'

  describe '#maxLen()', ->
    it 'should test the length of the string against a maximal length', ->
      cure.string.maxLen 11
        .exec 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .exec 'hello worlds', (err, value) ->
          expect(err).to.be 'maxLen'
          expect(value).to.be 'hello worlds'

        .exec 'hello', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello'

  describe '#len()', ->
    it 'should test the length of the string against a certain length', ->
      cure.string.len 11
        .exec 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .exec 'hello worlds', (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.be 'hello worlds'

        .exec 'hello', (err, value) ->
          expect(err).to.be 'len'
          expect(value).to.be 'hello'

  describe '#email()', ->
    it 'should test if the string is an email', ->
      cure.string.email()
        .exec 'hello@world.com', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello@world.com'

        .exec 'hello@world', (err, value) ->
          expect(err).to.be 'email'
          expect(value).to.be 'hello@world'

        .exec 'hello@world@world.com', (err, value) ->
          expect(err).to.be 'email'
          expect(value).to.be 'hello@world@world.com'

  describe '#match()', ->
    it 'should test if the string against a regex', ->
      # From http://net.tutsplus.com/tutorials/other/8-regular-expressions-you-should-know/
      cure.string.match /^[a-z0-9_-]{3,16}$/  
        .exec '-a', (err, value) ->
          expect(err).to.be 'match'
          expect(value).to.be '-a'

        .exec 'h3y', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'h3y'

        .exec 'azerty123456-_', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'azerty123456-_'

        .exec 'azerty123456-_qsdf', (err, value) ->
          expect(err).to.be 'match'
          expect(value).to.be 'azerty123456-_qsdf'
