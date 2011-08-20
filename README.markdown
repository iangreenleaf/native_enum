# ActiveRecord Enum

Provides ActiveRecord support for the nonstandard `ENUM` and `SET` data types.

[![Build Status](http://travis-ci.org/iangreenleaf/activerecord_enum.png)](http://travis-ci.org/iangreenleaf/activerecord_enum)

## Hypothetically asked questions

### Y U NO WORK?!
Sorry, it currently only works with Rails 3.0.x and the mysql2 adapter. I plan to support 3.1.x and other adapters at some point.

### Why doesn't it validate anything?
Right now it really only supports schema operations - attribute access is left untouched. I'll be working on that too at some point.

### Nonstandard SQL?! What's your problem, jerkweed?
This isn't a plugin everyone should use. There are a number of plugins to simulate enum behavior backed by standard data types. Personally, I like [nofxx/symbolize](https://github.com/nofxx/symbolize).

However, sometimes we can't or won't avoid working with these data types. When that happens, I got you covered.
