require 'rspec'
require 'sqlite3'
require 'activerecord_enum'

def db
  ENV["DB"] || "mysql"
end

def load_schema filename
  # silence verbose schema loading
  original_stdout = $stdout
  $stdout = StringIO.new

  root = File.expand_path(File.dirname(__FILE__))
  load root + "/schema/#{filename}.rb"

ensure
  $stdout = original_stdout
end

def dumped_schema
  stream = StringIO.new
  ActiveRecord::SchemaDumper.ignore_tables = []
  ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
  stream.string.lines.select {|l| /^\s*#/.match(l).nil? }.join
end

def column_props table, column
  case db
  when "mysql"
    result = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM #{table} WHERE Field='#{column}'"
    { :type => result["Type"], :default => result["Default"], :null => ( result["Null"] == "YES" ) }
  when "sqlite"
    result = ActiveRecord::Base.connection.select_value "SELECT sql FROM sqlite_master WHERE type='table' AND name='#{table}'"
    matches = /"#{column}" ([^[:space:]]+) (?:DEFAULT '([^[:space:]]+)')?( NOT NULL)?,/.match result
    { :type => matches[1], :default => matches[2], :null => matches[3].nil? }
  end
end

db_config = YAML::load(IO.read("spec/database.yml"))
ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection db
RSpec.configure do |c|
  c.filter_run_excluding :db_support => ! db_config[db]["supports_enums"]
end
