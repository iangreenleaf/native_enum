require 'rspec'
require 'activerecord_enum'

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

db_config = YAML::load(IO.read("spec/database.yml"))
ActiveRecord::Base.configurations = db_config
db = ENV["DB"] || "mysql"
ActiveRecord::Base.establish_connection db
RSpec.configure do |c|
  c.filter_run_excluding :db_support => ! db_config[db]["supports_enums"]
end
