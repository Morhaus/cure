_ = require 'lodash'

AnySchema = require './any'

module.exports = class ArraySchema extends AnySchema

StringSchema = require './string'

ArraySchema
  # Sanitization
  .action 'slice', (args...) ->
    @next (@value.slice args...)

  .action 'join', StringSchema, (args...) ->
    @next (@value.join args...)

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
