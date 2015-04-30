# ActiveRecord Enum #

Provides ActiveRecord (and thus Rails) support for the nonstandard `ENUM` and `SET` data types.

[![Build Status](https://travis-ci.org/iangreenleaf/activerecord_enum.png?branch=master)](http://travis-ci.org/iangreenleaf/activerecord_enum)

## How now? ##

It sucks to have ActiveRecord not understand your `ENUM` columns and constantly write the wrong thing to your `schema.rb`.
It also sucks to work with a database that uses `ENUM` in production when you'd prefer sqlite in development.
Wait no longer...

```ruby
create_table :balloons, :force => true do |t|
  t.enum "color", :limit => ['red', 'gold'], :default => 'gold', :null => false
  # or...
  t.column "size", :enum, :limit => ['small', 'medium', 'large']
end
```

Your schema<->db coupling will work again, and it will fall back to a `VARCHAR` column on any adapters that don't support `ENUM`.

## Installation ##

```
gem 'activerecord_enum'
```

Boy, that was easy.

## Hypothetically asked questions ##

### Y U NO WORK?! ###

It currently works with:

 * ActiveRecord 3.x and 4.0, 4.1, and 4.2.
 * The `mysql2` and `sqlite` adapters.
 * Ruby 1.9.3, 2.0.x, 2.1.x, and 2.2.x.

If you'd like to support other adapters, pull requests are welcome!

### Why doesn't it validate anything? ###

Following ActiveRecord's lead, this plugin doesn't do any validation work itself.

For ENUM columns, you may be satisfied with something simple:

    validates_inclusion_of :attr, :in => [ :possible, :values ]

Or if you prefer more bells and whistles, try [nofxx/symbolize](https://github.com/nofxx/symbolize).

For SET columns, you may be interested in [iangreenleaf/active_set](https://github.com/iangreenleaf/active_set).

### Nonstandard SQL?! What's your problem, jerkweed? ###

This isn't a plugin everyone should use. There are a number of plugins to simulate enum behavior backed by standard data types. Personally, I like [nofxx/symbolize](https://github.com/nofxx/symbolize).

However, sometimes we can't or won't avoid working with these data types. When that happens, I got you covered.

## Contributing ##

Pull requests welcome! Join
[this lovely bunch of people](https://github.com/iangreenleaf/activerecord_enum/graphs/contributors).


### Running the tests ###

To run the tests for all supported database adapters:

    rake spec:all

To run the tests for all adapters and all versions of ActiveRecord:

    rake spec:rails_all

To run the tests for just one adapter:

    DB=mysql rake spec
