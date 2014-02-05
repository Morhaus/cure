cure
====

Simple, clean and extensible object sanitization and validation.

Very much WIP.

```
var cure = require('cure');

var userSchema = cure.object.format({
  name: cure.string.trim().minLen(6).match(/^[a-zA-Z0-9]+$/),
  email: cure.string.trim().email(),
  password: cure.string.minLen(6),
  meta: cure.object.format({
    comments: cure.number.int().min(0),
    tags: cure.string.split(',')
  })
});
```

