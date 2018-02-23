[![Gem Version](https://badge.fury.io/rb/validated_object.svg)](https://badge.fury.io/rb/validated_object) [![Build Status](https://travis-ci.org/dogweather/validated_object.svg?branch=master)](https://travis-ci.org/dogweather/validated_object) [![Code Climate](https://codeclimate.com/github/dogweather/validated_object/badges/gpa.svg)](https://codeclimate.com/github/dogweather/validated_object)

# ValidatedObject

Plain Old Ruby Objects + Rails Validations = self-checking Ruby objects.


## Goals

* Very readable error messages
* Clean, minimal syntax

This is a small layer around
[ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates). (About 18 lines of code.) So if you know how to use Rails Validations, you're good to go. I wrote this to help with CSV data imports and [website microdata generation](https://github.com/dogweather/schema-dot-org).


## Usage


### Writing a self-validating object

All of the [ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates) are available, plus a new one, `TypeValidator`.

```ruby
class Dog < ValidatedObject::Base
  # Plain old Ruby
  attr_accessor :name, :birthday  # attr_reader is supported as well for read-only attributes

  # Plain old Rails
  validates :name, presence: true
  validates :birthday, type: Date, allow_nil: true  # Strongly typed but optional
end
```

The `TypeValidator` is what enables `type: Date`, above. All classes can be checked, as well as a pseudo-class `Boolean`. E.g.:

```ruby
#...
validates :premium_membership, type: Boolean
#...
```

### Instantiating and automatically validating

```ruby
# This Dog instance validates itself at the end of instantiation.
spot = Dog.new(name: 'Spot')
```

```ruby
# We can also explicitly test for validity because all of
# ActiveModel::Validations is available.
spot.valid?  # => true

spot.birthday = Date.new(2015, 1, 23)
spot.valid?  # => true
```

### Good error messages

Any of the standard Validations methods can be
used to test an instance, plus the custom `check_validations!` convenience method:

```ruby
spot.birthday = '2015-01-23'
spot.valid?  # => false
spot.check_validations!  # => ArgumentError: Birthday is a String, not a Date
```

Note the clear, explicit error message. These are great when reading a log
file following a data import. It describes all the invalid conditions. Let's 
test it by making another attribute invalid:

```ruby
spot.name = nil
spot.check_validations!  # => ArgumentError: Name can't be blank; Birthday is a String, not a Date
```


### Use in parsing data

I often use a validated object in a loop to import data, e.g.:

```ruby
# Import a CSV file of dogs
dogs = []
csv.next_row do |row|
  begin
    dogs << Dog.new(name: row.name)
  rescue ArgumentError => e
    logger.warn(e)
  end
end
```

The result is that `dogs` is an array of guaranteed valid Dog objects. And the
error log lists unparseable rows with good info for tracking down problems in
the data.

### Use in code generation

My [Schema.org microdata generation gem](https://github.com/dogweather/schema-dot-org) uses ValidatedObjects to recursively create well formed HTML / JSON-LD. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'validated_object'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validated_object



## Development

(TODO: Verify these instructions.) After checking out the repo, run `bin/setup`
to install dependencies. Then, run `rake spec` to run the tests. You can also
run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/dogweather/validated_object.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
