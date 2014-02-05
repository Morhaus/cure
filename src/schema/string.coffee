_ = require 'lodash'

AnySchema = require './any'

module.exports = class StringSchema extends AnySchema

ArraySchema = require './array'
ObjectSchema = require './object'

StringSchema
  # Sanitization
  .action 'split', ArraySchema, (args...) ->
    @next @value.split args...

  .action 'append', (str) ->
    @next @value + str

  .action 'prepend', (str) ->
    @next str + @value

  .action 'surround', (str) ->
    @next str + @value + str

  .action 'trim', ->
    if String::trim
      @next @value.trim()
    else
      @next (@value.replace /^\s+|\s+$/gm, '')

  .action 'parseJSON', ObjectSchema, ->
    @next (JSON.parse @value)

  # Validation
  .action 'includes', (values...) ->
    if (_.contains @value, values...)
      @next()
    else
      @fail()

  .action 'excludes', (val) ->
    unless (_.contains @value, values...)
      @next()
    else
      @fail()

  .action 'minLen', (min) ->
    if @value.length >= min then @next() else @fail()

  .action 'maxLen', (max) ->
    if @value.length <= max then @next() else @fail()

  .action 'len', (len) ->
    if @value.length is len then @next() else @fail()

  .action 'email', ->
    if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test @value) then @next() else @fail()

  .action 'match', (regex) ->
    if (regex.test @value) then @next() else @fail()
