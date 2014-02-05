_ = require 'lodash'

AnySchema = require './any'

module.exports = class DateSchema extends AnySchema

DateSchema
  # Validation
  .action 'before', (date) ->
    if @value.getTime() < date.getTime() then @next() else @fail()

  .action 'after', (date) ->
    if @value.getTime() > date.getTime() then @next() else @fail()
