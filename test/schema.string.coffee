expect = require 'expect.js'
cure = require '../src'

describe 'StringSchema', ->
  describe '#split()', ->
    it 'should split the string according to a sub-string', ->
      cure.string.split ' '
        .run 'hello there', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'there']

    it 'should split the string according to a regex', ->
      cure.string.split /\s+/
        .run 'hello hello    hiiii', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql ['hello', 'hello', 'hiiii']

  describe '#append()', ->
    it 'should append to the string', ->
      cure.string.append ' test'
        .run 'cat', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'cat test'

        .run '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be ' test'

  describe '#prepend()', ->
    it 'should prepend to the string', ->
      cure.string.prepend 'i like '
        .run 'cats', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like cats'

        .run '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like '

  describe '#surround()', ->
    it 'should surround the string', ->
      cure.string.surround 'o'
        .run '_', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'o_o'

        .run '', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'oo'

  describe '#trim()', ->
    it 'should trim the string', ->
      cure.string.trim()
        .run '      hello    hello     ', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello    hello'

        .run '  \t\n   hey\t', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hey'

  describe '#parseJSON()', ->
    it 'should parse JSON from the string', ->
      cure.string.parseJSON()
        .run '{"state":"hello"}', (err, value) ->
          expect(err).to.be null
          expect(value).to.eql { state: 'hello' }

  describe '#includes()', ->
    it 'should test for the inclusion of a sub-string', ->
      cure.string.includes 'cat'
        .run 'i like cats', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'i like cats'

        .run 'hello', (err, value) ->
          expect(err.message).to.be 'includes'
          expect(value).to.be undefined

    it 'should test for the inclusion of multiple sub-strings', ->
      cure.string.includes ['hello', 'there']
        .run 'hello there', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello there'

        .run 'hi there', (err, value) ->
          expect(err.message).to.be 'includes'
          expect(value).to.be undefined

  describe '#excludes()', ->
    it 'should test for the exclusion of a sub-string', ->
      cure.string.excludes 'cat'
        .run 'i like cats', (err, value) ->
          expect(err.message).to.be 'excludes'
          expect(value).to.be undefined

        .run 'hello', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello'

    it 'should test for the exclusion of multiple sub-strings', ->
      cure.string.excludes ['hello', 'there']
        .run 'what there', (err, value) ->
          expect(err.message).to.be 'excludes'
          expect(value).to.be undefined

        .run 'hi you', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hi you'

        .run 'hi hello', (err, value) ->
          expect(err.message).to.be 'excludes'
          expect(value).to.be undefined

  describe '#minLen()', ->
    it 'should test the length of the string against a minimal length', ->
      cure.string.minLen 11
        .run 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .run 'hello worlds', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello worlds'

        .run 'hello', (err, value) ->
          expect(err.message).to.be 'minLen'
          expect(value).to.be undefined

  describe '#maxLen()', ->
    it 'should test the length of the string against a maximal length', ->
      cure.string.maxLen 11
        .run 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .run 'hello worlds', (err, value) ->
          expect(err.message).to.be 'maxLen'
          expect(value).to.be undefined

        .run 'hello', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello'

  describe '#len()', ->
    it 'should test the length of the string against a certain length', ->
      cure.string.len 11
        .run 'hello world', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello world'

        .run 'hello worlds', (err, value) ->
          expect(err.message).to.be 'len'
          expect(value).to.be undefined

        .run 'hello', (err, value) ->
          expect(err.message).to.be 'len'
          expect(value).to.be undefined

  describe '#email()', ->
    it 'should test if the string is an email', ->
      cure.string.email()
        .run 'hello@world.com', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'hello@world.com'

        .run 'hello@world', (err, value) ->
          expect(err.message).to.be 'email'
          expect(value).to.be undefined

        .run 'hello@world@world.com', (err, value) ->
          expect(err.message).to.be 'email'
          expect(value).to.be undefined

  describe '#matches()', ->
    it 'should test the string against a regex', ->
      # From http://net.tutsplus.com/tutorials/other/8-regular-expressions-you-should-know/
      cure.string.matches /^[a-z0-9_-]{3,16}$/  
        .run '-a', (err, value) ->
          expect(err.message).to.be 'matches'
          expect(value).to.be undefined

        .run 'h3y', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'h3y'

        .run 'azerty123456-_', (err, value) ->
          expect(err).to.be null
          expect(value).to.be 'azerty123456-_'

        .run 'azerty123456-_qsdf', (err, value) ->
          expect(err.message).to.be 'matches'
          expect(value).to.be undefined
