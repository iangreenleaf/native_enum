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

ActiveRecord::Base.configurations = {
  "enum_test" => {
    :adapter => "mysql2",
    :host => "localhost",
    :username => "enum_test",
    :password => "enum_test",
    :database => "enum_test",
    :socket => "/tmp/mysql.sock"
  },
}
ActiveRecord::Base.establish_connection "enum_test"
