_ = require 'lodash'
async = require 'async'

Node = require '../node'
AnySchema = require './any'

class ObjectSchema extends AnySchema

ObjectSchema
  # Validation/Sanitization
  .action 'format', (object) ->
    errors = []

    dirty = new Node().setup @value
    clean = new Node().setup {}

    async.eachSeries (_.keys object), (key, nextKey) =>
      schema = object[key]
      nodePath = [key]
      node = dirty.resolve [key]
      nodeValue = node?.value or null
  
      schema.exec nodeValue, (err, newValue) ->
        if err
          errors.push { path: nodePath, error: err, type: schema.constructor.name }
        else
          clean.make nodePath, newValue
        nextKey()
    , =>
      if errors.length > 0
        @fail errors
      else
        @next clean.build()

module.exports = ObjectSchema
