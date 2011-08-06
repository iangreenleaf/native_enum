require 'test/unit'
require 'activerecord_enum'

def load_schema
  # silence verbose schema loading
  original_stdout = $stdout
  $stdout = StringIO.new

  root = File.expand_path(File.dirname(__FILE__))
  load root + "/schema.rb"

ensure
  $stdout = original_stdout
end

#load_schema

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
