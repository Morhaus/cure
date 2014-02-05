_ = require 'lodash'

AnySchema = require './any'

module.exports = class NumberSchema extends AnySchema

NumberSchema
  # Validation
  .action 'min', (min) ->
    if @value >= min then @next() else @fail()

  .action 'max', (max) ->
    if @value <= max then @next() else @fail()

  .action 'int', ->
    if @value % 1 is 0 then @next() else @fail()
