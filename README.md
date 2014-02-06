cure
====

Simple, clean and extensible object sanitization and validation.

Very much WIP.

Usage
-----
```
var cure = require('cure');
```

## Defining a schema

`cure.{object, string, number, ...}` are instances of (respectively) `cure.Schema.{Object, String, Number, ...}`, with an added `type` validation.

For example, `cure.string.trim()` is a shorthand for `new cure.Schema.String().type(String).trim()`.

It is important to note that calling an action on a schema does not modify the schema, but rather returns a new schema.

```
var emailSchema1 = cure.string.email();
var emailSchema2 = emailSchema1.includes('pony');
emailSchema1 !== emailSchema2;
```

### Schema.String

**Example**

```
var nameSchema = cure.string.trim().minLen(6).match(/^[a-zA-Z0-9]+$/);
```

### Schema.Object

**Example**

```
var userSchema = cure.object.format({
  name: nameSchema,
  email: cure.string.trim().email(),
  meta: cure.object.format({
    comments: cure.number.int().min(0),
    tags: cure.string.split(',')
  })
});
```

## Validating a schema

```
nameSchema.validate('__whatever', function(err, value) {
  err == 'match';
});
```

If `err` is defined, it will be the name of the validation that failed.

If no errors are met, `value` contains the sanitized object.
```
nameSchema.validate(' \t validName\n', function(err, value) {
  value == 'validName';
});
```
### object.format()

If an error is met in the `format` action of `Schema.Object`, `err` is an array of errors met during the validation of the different key/schema pairs. `value` is the untouched input object.
```
userSchema.validate({
  name: ' Morhaus ',
  email: 'morhaus@google@google.com',
  meta: {
    comments: -1,
    tags: 'user,admin'
  }
}, function(err, value) {
  err == [{
    path: ['email'],
    type: 'StringSchema'
    error: 'email'
  }, {
    path: ['meta'],
    type: 'ObjectSchema'
    error: [{
      path: ['comments'],
      type: 'NumberSchema',
      error: 'min'
    }]
  }];
})
```

If no errors are met, `value` contains the sanitized object.
```
userSchema.validate({
  name: ' Morhaus ',
  email: 'morhaus@google.com',
  ignored: true,
  meta: {
    comments: 2,
    tags: 'user,admin'
  }
}, function(err, value) {
  value == {
    name: 'Morhaus',
    email: 'morhaus@google.com',
    meta: {
      comments: 2,
      tags: ['user', 'admin']
    }
  };
});
```

## Extending

All `Schema` constructors have an `action(name, [newType], fn)` method to register new actions.
```
cure.Schema.String.action('contains', function(str) {
  if (this.value.indexOf(str) !== -1) {
    this.next(); // calls the next action
  } else {
    this.fail(); // stops the validation, returns 'contains' error
  }
});

cure.string.contains('test').validate('_test_', function(err, value) {
  err == null;
});
```

An action can return a different `Schema` type than the one it was registered for. 
```
cure.Schema.String.action('split', Schema.Array, function(str) {
  // the value passed to this.next() will be passed to every subsequent actions,
  // and eventually returned by the callback argument of Schema::validate()
  this.next(this.value.split(str));
});

cure.string.split('.').join(', ').validate('hello.world', function(err, value) {
  value == 'hello, world';
});
```

Actions are executed asynchronously, in the order they were called on the `Schema` object. This allows for I/O operations.
```
cure.Schema.Any.action('unique', function(key, model) {
  var select = {};
  select[key] = this.value;
  model.findOne(select, function(err, doc) {
    if (err) {
      // this.fail() can be passed an error, which will replace the default ('unique' in this case)
      this.fail(err);
    } else if (doc) {
      this.fail();
    } else {
      this.next();
    }
  });
});

cure.string.unique('name', UserModel)
```

You can also define your own schema constructors if you don't feel like extending the already existing ones.
```
var util = require('util');
var cure = require('cure');

function CatSchema() {
  cure.Schema.String.call(this);
}

util.inherits(CatSchema, cure.Schema.String);

CatSchema.action('meow', function() {
  this.next(@value + ' meow');
});
```
