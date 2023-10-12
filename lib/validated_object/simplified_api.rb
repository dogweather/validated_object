require "active_support/concern"

module ValidatedObject
  module SimplifiedApi
    extend ActiveSupport::Concern

    class_methods do
      def validated_attr(attribute, *options)
        attr_reader attribute
        validates attribute, *options
      end
    end

  end
end
