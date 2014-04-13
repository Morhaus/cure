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
  .action 'includes', (values, err) ->
    values = [values] unless _.isArray values
    for value in values
      unless (_.contains @value, value)
        return @fail err

    @next()

  .action 'excludes', (values, err) ->
    values = [values] unless _.isArray values
    for value in values
      if (_.contains @value, value)
        return @fail err

    @next()

  .action 'minLen', (min, err) ->
    if @value.length >= min then @next() else @fail err

  .action 'maxLen', (max, err) ->
    if @value.length <= max then @next() else @fail err

  .action 'len', (len, err) ->
    if @value.length is len then @next() else @fail err

  .action 'email', (err) ->
    if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test @value) then @next() else @fail err

  .action 'match', (regex, err) ->
    if (regex.test @value) then @next() else @fail err
