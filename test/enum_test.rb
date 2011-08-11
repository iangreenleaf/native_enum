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

  private
  def standard_dump
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end
end
