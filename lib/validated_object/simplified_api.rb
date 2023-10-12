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
    end

  end
end
