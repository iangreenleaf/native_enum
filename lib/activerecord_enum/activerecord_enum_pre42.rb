module ActiveRecord
  module ConnectionAdapters
    class Column
      def initialize_with_enum name, default, sql_type=nil, *args
        initialize_without_enum name, default, sql_type, *args
        @type = simplified_type_with_enum sql_type
        @limit = extract_limit_with_enum sql_type
        @default = extract_default_with_enum default
      end
      alias_method :initialize_without_enum, :initialize
      alias_method :initialize, :initialize_with_enum

      def simplified_type_with_enum field_type
        if field_type =~ /enum|set/i
          $&.to_sym
        else
          simplified_type field_type
        end
      end

      def extract_limit_with_enum field_type
        if field_type =~ /(?:enum|set)\(([^)]+)\)/i
          $1.scan( /'([^']*)'/ ).flatten
        else
          extract_limit field_type
        end
      end

      def extract_default_with_enum default
        if type == :set
          default.split "," if default.present?
        else
          extract_default default
        end
      end

      def set?
        type == :set
      end

      def enum?
        type == :enum
      end
    end
  end
end
