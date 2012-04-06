# ActiveRecord Enum #

Provides ActiveRecord support for the nonstandard `ENUM` and `SET` data types.

[![Build Status](http://travis-ci.org/iangreenleaf/activerecord_enum.png)](http://travis-ci.org/iangreenleaf/activerecord_enum)

## Running the tests ##

To run the tests for all supported database adapters:

    rake spec:all

To run the tests for all adapters and all versions of ActiveRecord:

    ./spec/all_rails

To run the tests for just one adapter:

    DB=mysql rake spec

## Hypothetically asked questions ##

### Y U NO WORK?! ###

Sorry, it currently only works with Rails 3.x and the mysql2 and sqlite adapters. I plan to support other standard adapters at some point.

### Why doesn't it validate anything? ###

Following ActiveRecord's lead, this plugin doesn't do any validation work itself.

For ENUM columns, you may be satisfied with something simple:

    validates_inclusion_of :attr, :in => [ :possible, :values ]

Or if you prefer more bells and whistles, try [nofxx/symbolize](https://github.com/nofxx/symbolize).

For SET columns, you may be interested in [iangreenleaf/active_set](https://github.com/iangreenleaf/active_set).

### Nonstandard SQL?! What's your problem, jerkweed? ###

This isn't a plugin everyone should use. There are a number of plugins to simulate enum behavior backed by standard data types. Personally, I like [nofxx/symbolize](https://github.com/nofxx/symbolize).

However, sometimes we can't or won't avoid working with these data types. When that happens, I got you covered.
