require 'active_model'
require "validated_object/version"

module ValidatedObject
  # @abstract Subclass and add `attr_accessor` and validations
  #   to create custom validating objects.
  #
  # Uses [ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates)
  # to create self-validating Plain Old Ruby objects. This is especially
  # useful when importing data from one system into another. This class also
  # creates very readable error messages.
  #
  # @example Writing a self-validating object
  #   class Dog < Eaternet::ValidatedObject
  #     attr_accessor :name, :birthday
  #
  #     validates :name, presence: true
  #     validates :birthday, type: Date, allow_nil: true
  #   end
  #
  # @example Instantiating and automatically validating
  #   # The dog1 instance validates itself at the end of instantiation.
  #   # Here, it succeeds and so doesn't raise an exception.
  #   dog1 = Dog.new do |d|
  #     d.name = 'Spot'
  #   end
  #
  #   # We can also explicitly test for validity
  #   dog1.valid?  # => true
  #
  #   dog1.birthday = Date.new(2015, 1, 23)
  #   dog1.valid?  # => true
  #
  # @example Making an instance invalid
  #   dog1.birthday = '2015-01-23'
  #   dog1.valid?  # => false
  #   dog1.check_validations!  # => ArgumentError: Birthday is class String, not Date
  #
  # @see Eaternet::ValidatedObject::TypeValidator
  # @see http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/ ActiveModel: Make Any Ruby Object Feel Like ActiveRecord, Yehuda Katz
  # @see http://www.rubyinside.com/rails-3-0s-activemodel-how-to-give-ruby-classes-some-activerecord-magic-2937.html Rails 3.0′s ActiveModel: How To Give Ruby Classes Some ActiveRecord Magic, Peter Cooper
  class Base
    include ActiveModel::Validations

    # Instantiate and validate a new object.
    #
    # @yieldparam [ValidatedObject] new_object the yielded new object
    #   for configuration.
    #
    # @raise [ArgumentError] if the object is not valid at the
    #   end of initialization.
    def initialize(&block)
      block.call(self)
      check_validations!
    end

    # Run any validations and raise an error if invalid.
    # @raise [ArgumentError] if any validations fail.
    def check_validations!
      fail ArgumentError, errors.full_messages.join('; ') if invalid?
    end

    # A custom validator which ensures an object is a certain class.
    # It's here as a nested class in {ValidatedObject} for easy
    # access by subclasses.
    #
    # @example Ensure that weight is a floating point number
    #   class Dog < ValidatedObject
    #     attr_accessor :weight
    #     validates :weight, type: Float
    #   end
    class TypeValidator < ActiveModel::EachValidator
      # @return [nil]
      def validate_each(record, attribute, value)
        expected = options[:with]
        actual = value.class
        return if actual == expected

        msg = options[:message] || "is class #{actual}, not #{expected}"
        record.errors.add attribute, msg
      end
    end
  end
end
