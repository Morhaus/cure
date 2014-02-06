_ = require 'lodash'

normalizePath = (path) -> if typeof path is 'string' then path.split '.' else path[..]

module.exports = class Node
  constructor: (@path = []) ->

  setup: (value) ->
    @clear() if @value

    @value = value

    return this unless (_.isPlainObject value)

    @nodes = {}
    for nodeName, nodeValue of @value
      nodePath = @path.concat [nodeName]
      node = @nodes[nodeName] = new Node nodePath
      node.setup nodeValue

    return this

  clear: ->
    delete @value
    delete @nodes if @nodes

    return this

  # Returns the node that matches a given path
  resolve: (path) ->
    path = normalizePath path
    return @ if path.length is 0

    nodeName = path.shift()

    if @nodes and @nodes[nodeName]
      # The target exists, we resume resolving from it
      node = @nodes[nodeName]
      return node.resolve path

    else
      # The target node doesn't exist
      return null

  # Builds a node tree along a given path
  make: (path, value) =>
    path = normalizePath path
    return (@setup value) if path.length is 0

    nodeName = path.shift()

    @setup {} unless @nodes

    if @nodes[nodeName]
      # The target exists, we continue making from it
      node = @nodes[nodeName]
      return node.make path, value

    else
      # The target doesn't exist, we create it
      nodePath = @path.concat [nodeName]
      node = @nodes[nodeName] = new Node nodePath
      return node.make path, value

  # Builds a new object from the node tree
  build: =>
    return @value unless @nodes

    output = {}
    output[nodeName] = node.build() for nodeName, node of @nodes
    return output
