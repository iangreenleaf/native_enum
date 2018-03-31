require 'rspec'
require 'yaml'

module DBConfig
  class << self
    def db
      ENV["DB"] || "mysql"
    end

    def all_configs
      @all_configs ||= YAML::load(IO.read("spec/database.yml"))
    end

    def current
      all_configs[db]
    end
  end
end

module DatabaseHelpers
  def load_schema(filename)
    root = File.expand_path(File.dirname(__FILE__))
    load root + "/schema/#{filename}.rb"
  end

  def dumped_schema
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string.lines.select {|l| /^\s*#/.match(l).nil? }.join
  end

  def column_props(table, column)
    case DBConfig.db
    when "mysql"
      result = ActiveRecord::Base.connection.select_one(
        "SHOW FIELDS FROM #{table} WHERE Field='#{column}'"
      )
      {
        :type => result["Type"],
        :default => result["Default"],
        :null => ( result["Null"] == "YES" )
      }
    when "sqlite"
      result = ActiveRecord::Base.connection.select_value "SELECT sql FROM sqlite_master WHERE type='table' AND name='#{table}'"
      matches = /"#{column}" ([^[:space:]]+) (?:DEFAULT '([^[:space:]]+)')?( NOT NULL)?,/.match result
      { :type => matches[1], :default => matches[2], :null => matches[3].nil? }
    end
  end

  def db_config
    DBConfig.db_config
  end

  def db
    DBConfig.db
  end
end

require DBConfig.current["adapter"]
require 'native_enum'

RSpec.configure do |c|
  c.disable_monkey_patching!
  c.expose_dsl_globally = false

  c.include DatabaseHelpers
  c.filter_run_excluding db_support: !DBConfig.current["supports_enums"]
  c.before :suite do
    db_config = DBConfig.all_configs
    db = DBConfig.db
    ActiveRecord::Base.configurations = db_config
    ActiveRecord::Base.establish_connection db.to_sym
    # Silence AR's logging (e.g. when loading the schema)
    ActiveRecord::Migration.verbose = false
  end
end
