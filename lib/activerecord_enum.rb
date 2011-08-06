require 'active_record'
require 'active_record/connection_adapters/mysql2_adapter'

module ActiverecordEnum
end

module ActiveRecord
  module ConnectionAdapters
    class Mysql2Adapter < AbstractAdapter
      def native_database_types_with_enum
        native_database_types_without_enum.merge( :enum => { :name => "enum" } )
      end
      alias_method :native_database_types_without_enum, :native_database_types
      alias_method :native_database_types, :native_database_types_with_enum
    end
  end
end
#require 'activerecord_enum/railtie' if defined?(Rails)
