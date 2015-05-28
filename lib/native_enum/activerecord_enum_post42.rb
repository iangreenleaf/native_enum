module ActiveRecord
  module ConnectionAdapters
    if defined?(AbstractMysqlAdapter)
      class AbstractMysqlAdapter
        protected
        def initialize_type_map_with_enum(m)
          initialize_without_enum(m)
          register_enum_type(m, %r(^enum)i)
          register_set_type(m, %r(^set)i)
        end

        alias_method :initialize_without_enum, :initialize_type_map
        alias_method :initialize_type_map, :initialize_type_map_with_enum

        def register_enum_type(mapping, key)
          mapping.register_type(key) do |sql_type|
            if sql_type =~ /(?:enum)\(([^)]+)\)/i
              limit = $1.scan( /'([^']*)'/ ).flatten
              Type::Enum.new(limit: limit)
            end
          end
        end

        def register_set_type(mapping, key)
          mapping.register_type(key) do |sql_type|
            if sql_type =~ /(?:set)\(([^)]+)\)/i
              limit = $1.scan( /'([^']*)'/ ).flatten
              Type::Set.new(limit: limit)
            end
          end
        end
      end
    end
  end

  module Type
    class Enum < Type::Value
      def type
        :enum
      end

      def initialize(options = {})
        options.assert_valid_keys(:limit)
        @limit = options[:limit]
      end
    end

    class Set < Type::Value
      def type
        :set
      end

      def initialize(options = {})
        options.assert_valid_keys(:limit)
        @limit = options[:limit]
      end

      def type_cast_from_database(value)
        value.split(",")
      end
    end
  end
end
