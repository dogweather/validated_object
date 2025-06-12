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

      # Alias for validated_attr for compatibility with test usage.
      def validates_attr(attribute, *options, **kwargs)
        attr_reader attribute
        if kwargs[:type]
          type_val = kwargs.delete(:type)
          element_type = kwargs.delete(:element_type)
          opts = { type: { with: type_val } }
          opts[:type][:element_type] = element_type if element_type
          validates attribute, opts.merge(kwargs)
        else
          validates attribute, *options, **kwargs
        end
      end
    end

  end
end
