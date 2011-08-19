require 'test_helper'

class EnumTest < ActiveRecord::TestCase
  def setup
    load_schema
  end

  def test_dumps_native_format
    output = standard_dump
    assert_match %r{t\.enum\s+"color",\s+:limit => \["blue", "red", "yellow"\]}, output
  end

  def test_dumps_default_option
    output = standard_dump
    assert_match %r{t\.enum\s+"color",.+:default => "red"}, output
  end

  def test_dumps_null_option
    output = standard_dump
    assert_match %r{t\.enum\s+"color",.+:null => false$}, output
  end

  def test_loads_native_format
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='color'"
    assert_equal "enum('red','gold')", desc[ "Type" ]
  end

  def test_loads_native_column_format
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='size'"
    assert_equal "enum('small','medium','large')", desc[ "Type" ]
  end

  def test_loads_default_option
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='color'"
    assert_equal "gold", desc[ "Default" ]
  end

  def test_loads_null_option
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='color'"
    assert_equal "NO", desc[ "Null" ]
  end

  private
  def standard_dump
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end
end
