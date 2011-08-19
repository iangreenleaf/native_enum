require 'spec_helper'

describe "activerecord_enum" do

  before do
    load_schema
  end

  it "dumps native format" do
    output = standard_dump
    output.should match %r{t\.enum\s+"color",\s+:limit => \["blue", "red", "yellow"\]}
  end

  it "dumps default option" do
    output = standard_dump
    output.should match %r{t\.enum\s+"color",.+:default => "red"}
  end

  it "dumps null option" do
    output = standard_dump
    output.should match %r{t\.enum\s+"color",.+:null => false$}
  end

  it "loads native format" do
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='color'"
    desc[ "Type" ].should == "enum('red','gold')"
  end

  it "loads native column format" do
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='size'"
    desc[ "Type" ].should == "enum('small','medium','large')"
  end

  it "loads default option" do
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='color'"
    desc[ "Default" ].should == "gold"
  end

  it "loads null option" do
    load_schema "schema_new"
    desc = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='color'"
    desc[ "Null" ].should == "NO"
  end

  private
  def standard_dump
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end
end
