require 'rspec'
require 'activerecord_enum'

def load_schema filename="schema"
  # silence verbose schema loading
  original_stdout = $stdout
  $stdout = StringIO.new

  root = File.expand_path(File.dirname(__FILE__))
  load root + "/#{filename}.rb"

ensure
  $stdout = original_stdout
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