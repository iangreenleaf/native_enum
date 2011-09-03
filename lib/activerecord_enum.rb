require 'active_record'
require 'active_record/base'
require 'active_record/connection_adapters/mysql2_adapter'
require 'active_record/connection_adapters/abstract/schema_definitions.rb'
require 'active_record/attribute_methods/write'

module ActiveRecord
  module AttributeMethods
    module Write
      def write_attribute_with_enum(attr_name, value)
        if (column = column_for_attribute(attr_name)) && column.set? && value.respond_to?(:join)
          value = value.join ","
        end
        write_attribute_without_enum attr_name, value
      end
      alias_method :write_attribute_without_enum, :write_attribute
      alias_method :write_attribute, :write_attribute_with_enum
    end
  end
end

module ActiveRecord
  module ConnectionAdapters
    class Mysql2Adapter < AbstractAdapter
      def native_database_types_with_enum
        native_database_types_without_enum.merge( :enum => { :name => "enum" }, :set => { :name => "set" } )
      end
      alias_method :native_database_types_without_enum, :native_database_types
      alias_method :native_database_types, :native_database_types_with_enum

      def type_to_sql_with_enum type, limit=nil, *args
        if type.to_s == "enum" || type.to_s == "set"
          "#{type}(#{quoted_comma_list limit})"
        else
          type_to_sql_without_enum type, limit, *args
        end
      end
      alias_method :type_to_sql_without_enum, :type_to_sql
      alias_method :type_to_sql, :type_to_sql_with_enum

      private
      def quoted_comma_list list
        list.to_a.map{|n| "'#{n}'"}.join(",")
      end
    end
  end
end

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
module ActiveRecord
  module ConnectionAdapters
    class TableDefinition
      def enum *args
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, :enum, options) }
      end
      def set *args
        options = args.extract_options!
        options[:default] = options[:default].join "," if options[:default].present?
        column_names = args
        column_names.each { |name| column(name, :set, options) }
      end
    end
  end
end
