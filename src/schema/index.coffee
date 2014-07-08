Promise = require 'bluebird'
async = require 'async'
_ = require 'lodash'

CureError = require '../error'

module.exports = class Schema
  @define: (name, args...) ->
    if args.length is 1
      [fn] = args
    else
      [type, fn] = args

    @::[name] = (args...) ->
      actions = @_actions.concat [{name, fn, args}]
      opts = _.clone @_opts
      ctor = type or @constructor
      return (new ctor actions, opts)

    return @

  constructor: (@_actions = [], @_opts = {}) ->

  run: (initialValue, callback) =>
    run = (runCallback) =>
      unless initialValue?
        if @_opts.default?
          runCallback null, @_opts.default
        else if @_opts.optional
          runCallback null
        else
          runCallback (new CureError 'required', initialValue)
        return

      actionStep = (value, action, next) ->
        actionCallback = (err, value, skip) ->
          if err?
            if typeof err is 'boolean'
              err = new CureError action.name, value
            else if typeof err is 'string'
              err = new CureError err, value
            else unless err instanceof CureError
              throw new Error 'invalid error parameter'
            next err
          else if skip
            runCallback null, value
          else
            next null, value

        if action.fn.length is 2
          action.fn value, actionCallback
        else if action.fn.length is 3
          action.fn value, action.args, actionCallback

      async.reduce @_actions, initialValue, actionStep, runCallback

    if callback?
      run callback
      return @
    else
      new Promise (resolve, reject) =>
        run (err, result) ->
          if err?
            reject err
          else
            resolve result

  default: (value) ->
    opts = _.clone @_opts
    actions = _.clone @_actions
    opts.default = value
    return new @constructor actions, opts

  optional: ->
    opts = _.clone @_opts
    actions = _.clone @_actions
    opts.optional = yes
    return new @constructor actions, opts

Schema.Any = require './any'
Schema.Object = require './object'
Schema.Array = require './array'
Schema.Number = require './number'
Schema.String = require './string'
Schema.Date = require './date'
Schema.Boolean = require './boolean'
Schema.RegExp = require './regexp'
Schema.Function = require './function'
