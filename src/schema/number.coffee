_ = require 'lodash'

AnySchema = require './any'

module.exports = class NumberSchema extends AnySchema

NumberSchema
  # Validation
  .action 'min', (min, err) ->
    if @value >= min then @next() else @fail err

  .action 'max', (max, err) ->
    if @value <= max then @next() else @fail err

  .action 'int', (err) ->
    if @value % 1 is 0 then @next() else @fail err
