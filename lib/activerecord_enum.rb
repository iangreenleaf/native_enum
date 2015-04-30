require 'active_record'
require 'active_record/base'
require 'active_record/connection_adapters/abstract/schema_definitions.rb'

require 'connection_adapters/sqlite3' if defined?( SQLite3 )
require 'connection_adapters/mysql2' if defined?( Mysql2 )

ACTIVE_RECORD_VERSION = ActiveRecord::VERSION

if ACTIVE_RECORD_VERSION::MAJOR < 4 || (ACTIVE_RECORD_VERSION::MAJOR == 4 && ACTIVE_RECORD_VERSION::MINOR <= 1)
  require 'activerecord_enum/activerecord_enum_pre42.rb'
else
  require 'activerecord_enum/activerecord_enum_post42.rb'
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
