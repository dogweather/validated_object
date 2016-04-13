[![Gem Version](https://badge.fury.io/rb/validated_object.svg)](https://badge.fury.io/rb/validated_object) [![Build Status](https://travis-ci.org/dogweather/validated_object.svg?branch=master)](https://travis-ci.org/dogweather/validated_object) [![Code Climate](https://codeclimate.com/github/dogweather/validated_object/badges/gpa.svg)](https://codeclimate.com/github/dogweather/validated_object)

# ValidatedObject

Create self-validating Ruby objects with minimal code. Uses
[ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates).
I wrote it to help with CSV data imports. I wanted:

* Very readable error messages
* Clean minimal syntax


## Usage


### Writing a self-validating object

All of the [ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates) are available, plus a new one, `TypeValidator`.

```ruby
class Dog < ValidatedObject::Base
  attr_accessor :name, :birthday

  validates :name, presence: true
  validates :birthday, type: Date, allow_nil: true
end
```

### Instantiating and automatically validating

```ruby
# This Dog instance validates itself at the end of instantiation. Thus, a
# block-style constructor is necessary. Here, it succeeds and so doesn't raise
# an exception.
spot = Dog.new do |d|
  d.name = 'Spot'
end
```

> This example also demonstrates the extent of my meta-programming skills. ;-) I
decided to simply implement my client code using inheritance and block
constructors, ensuring that the `initializer` will always test for validity and
throw an exeption if needed.

```ruby
# We can also explicitly test for validity because all of
# ActiveModel::Validations is available.
spot.valid?  # => true

spot.birthday = Date.new(2015, 1, 23)
spot.valid?  # => true
```

### Demonstrating an invalid instance

An instance can become invalid. Any of the standard Validations methods can be
used to test it, or the custom `check_validations!` convenience method.

```ruby
spot.birthday = '2015-01-23'
spot.valid?  # => false
spot.check_validations!  # => ArgumentError: Birthday is class String, not Date
```

> Note the clear, explicit error message. These are great when reading a log
file following a data import.


### Use in parsing data

I often use a validated object in a loop to import data, e.g.:

```ruby
# Import a CSV file of dogs
dogs = []
csv.next_row do |row|
  begin
    dogs << Dog.new { |d| d.name = row.name }
  rescue ArgumentError => e
    logger.warn(e)
  end
end
```

The result is that `dogs` is an array of guaranteed valid Dog objects. And the
error log lists unparseable rows with good info for tracking down problems in
the data.

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
