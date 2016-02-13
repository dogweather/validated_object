[![Gem Version](https://badge.fury.io/rb/validated_object.svg)](https://badge.fury.io/rb/validated_object) [![Build Status](https://travis-ci.org/dogweather/validated_object.svg?branch=master)](https://travis-ci.org/dogweather/validated_object) [![Code Climate](https://codeclimate.com/github/dogweather/validated_object/badges/gpa.svg)](https://codeclimate.com/github/dogweather/validated_object)

# ValidatedObject

Uses
[ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates)
to create self-validating Plain Old Ruby objects. I wrote it for helping with CSV data imports into my Rails apps.
Very readable error messages are also important in that context, to track down parsing errors. This gem provides those too.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'validated_object'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validated_object

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
# The dog1 instance validates itself at the end of instantiation.
# Here, it succeeds and so doesn't raise an exception.
dog1 = Dog.new do |d|
  d.name = 'Spot'
end

# We can also explicitly test for validity
dog1.valid?  # => true

dog1.birthday = Date.new(2015, 1, 23)
dog1.valid?  # => true
```

### Making an instance invalid

```ruby
dog1.birthday = '2015-01-23'
dog1.valid?  # => false
dog1.check_validations!  # => ArgumentError: Birthday is class String, not Date
```


## Development

(TODO: Verify these instructions.) After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dogweather/validated_object.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
