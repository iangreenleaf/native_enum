require 'active_record'
require 'active_record/base'
require 'active_record/connection_adapters/abstract/schema_definitions.rb'

require 'connection_adapters/sqlite3' if defined?( SQLite3 )
require 'connection_adapters/mysql2' if defined?( Mysql2 )

if ActiveRecord::VERSION::MAJOR < 4 || (ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR <= 1)
  require 'activerecord_enum/activerecord_enum_pre42.rb'
else
  require 'activerecord_enum/activerecord_enum_post42.rb'
end

module ActiveRecord
  module ConnectionAdapters
    class TableDefinition

      def enum *args
        if defined?(ActiveSupport)
          ActiveSupport::Deprecation.warn(
            %q{The 'activerecord_enum' gem has a new name! Please install the 'native_enum' gem instead.}
          )
        end
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, :enum, options) }
      end
      def set *args
        if defined?(ActiveSupport)
          ActiveSupport::Deprecation.warn(
            %q{The 'activerecord_enum' gem has a new name! Please install the 'native_enum' gem instead.}
          )
        end
        options = args.extract_options!
        options[:default] = options[:default].join "," if options[:default].present?
        column_names = args
        column_names.each { |name| column(name, :set, options) }
      end
    end
  end
end
