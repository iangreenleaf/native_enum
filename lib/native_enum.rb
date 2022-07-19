require 'active_record'
require 'active_record/base'
require 'active_record/connection_adapters/abstract/schema_definitions.rb'

require 'connection_adapters/sqlite3' if defined?( SQLite3 )
require 'connection_adapters/mysql2' if defined?( Mysql2 )

if ActiveRecord::VERSION::MAJOR < 4 || (ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR <= 1)
  require 'native_enum/activerecord_enum_pre42.rb'
elsif ActiveRecord::VERSION::MAJOR < 7
  require 'native_enum/activerecord_enum_post42.rb'
else
  require 'native_enum/activerecord_enum_post7.rb'
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
