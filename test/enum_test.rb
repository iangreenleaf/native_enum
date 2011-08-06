require 'test_helper'

class EnumTest < ActiveRecord::TestCase
  def setup
    load_schema
  end

  def test_dumps_native_format
puts ActiveRecord::Base.connection.native_database_types[:enum].inspect
    output = standard_dump
    assert_match %r{t.enum\s+"color"$}, output
  end

  private
  def standard_dump
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end
end
