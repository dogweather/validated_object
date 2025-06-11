require "active_support/concern"

# Enable a simplified API for the common case of
# read-only ValidatedObjects.
module ValidatedObject
  module SimplifiedApi
    extend ActiveSupport::Concern

    class_methods do
      # Simply delegate to `attr_reader` and `validates`.
      def validated_attr(attribute, *options)
        attr_reader attribute
        validates attribute, *options
      end

      # Allow 'validated' as a synonym for 'validates'.
      def validated(*args, **kwargs, &block)
        validates(*args, **kwargs, &block)
      end
    end

  end
end
