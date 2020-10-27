module ActiveModelAttributes
  module Type
    module Rails4
      extend ActiveSupport::Concern

      module ClassMethods
        require 'active_support/core_ext/hash/keys'

        def lookup(symbol)
          registry[symbol]
        end

        def cast(type, value)
          type.type_cast_from_user(value)
        end

        def default_value
          @default_value ||= ActiveModel::Type::Value.new
        end

        private

        def registry
          @registry ||= Hash.new do |h, name|
            h[name] = find_type(name).new
          end
        end

        def find_type(name)
          classified = ActiveSupport::Inflector.classify(name.to_s)
          binding.pry
          ActiveRecord::Type.const_get(classified)
        rescue NameError
          raise ArgumentError, "Unknown type #{name}"
        end
      end
    end
  end
end
