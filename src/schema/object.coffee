_ = require 'lodash'
async = require 'async'

AnySchema = require './any'

class ObjectSchema extends AnySchema

ObjectSchema
  # Validation/Sanitization
  .define 'format', (value, [schemas], callback) ->
    errors = []
    formatted = {}

    async.eachSeries (_.keys schemas), (key, next) ->
      schemas[key].run value[key], (err, newValue) ->
        if err
          errors.push {key, err}
        else
          formatted[key] = newValue
        next()
    , ->
      if errors.length > 0
        callback errors, value
      else
        callback null, formatted

module.exports = ObjectSchema
