Schema = require './schema'

exports.any = new Schema.Any()

exports.object = new Schema.Object().type Object

exports.array = new Schema.Array().type Array

exports.string = new Schema.String().type String

exports.number = new Schema.Number().type Number

exports.boolean = new Schema.Boolean().type Boolean

exports.date = new Schema.Date().type Date

exports.regexp = new Schema.RegExp().type RegExp

exports.function = new Schema.Function().type Function

exports.Schema = Schema
