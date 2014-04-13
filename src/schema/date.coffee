_ = require 'lodash'

AnySchema = require './any'

module.exports = class DateSchema extends AnySchema

DateSchema
  # Validation
  .action 'before', (date, err) ->
    if @value.getTime() < date.getTime() then @next() else @fail err

  .action 'after', (date, err) ->
    if @value.getTime() > date.getTime() then @next() else @fail err
