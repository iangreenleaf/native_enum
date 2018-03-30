require 'active_record/connection_adapters/mysql2_adapter'

module ActiveRecord
  module ConnectionAdapters
    existing_class = defined?(Mysql2Adapter) ? Mysql2Adapter : AbstractMysqlAdapter

    existing_class.class_eval do
      def native_database_types_with_enum
        native_database_types_without_enum.merge({
          :enum => { :name => "enum" },
          :set => { :name => "set" }
        })
      end
      alias_method :native_database_types_without_enum, :native_database_types
      alias_method :native_database_types, :native_database_types_with_enum



      if ActiveRecord::VERSION::MAJOR >= 5 && ActiveRecord::VERSION::MINOR >= 1
        def type_to_sql_with_enum(type, limit: nil, **args)
          if type.to_s == "enum" || type.to_s == "set"
            list = limit
            if limit.is_a?(Hash)
              list = limit[:limit]
            end
            "#{type}(#{quoted_comma_list(list)})"
          else
            type_to_sql_without_enum(type, limit: limit, **args)
          end
        end
      else
        def type_to_sql_with_enum(type, limit=nil, *args)
          if type.to_s == "enum" || type.to_s == "set"
            list = limit
            if limit.is_a?(Hash)
              list = limit[:limit]
            end
            "#{type}(#{quoted_comma_list(list)})"
          else
            type_to_sql_without_enum(type, limit, *args)
          end
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
