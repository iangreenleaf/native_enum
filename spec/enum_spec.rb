require 'spec_helper'

describe "activerecord_enum" do

  describe "schema dump" do
    before { load_schema "enum_old" }
    subject { standard_dump }

    it "dumps native format" do
      subject.should match %r{t\.enum\s+"color",\s+:limit => \["blue", "red", "yellow"\]}
    end

    it "dumps default option" do
      subject.should match %r{t\.enum\s+"color",.+:default => "red"}
    end

    it "dumps null option" do
      subject.should match %r{t\.enum\s+"color",.+:null => false$}
    end
  end

  describe "schema loading" do
    before { load_schema "enum_new" }
    subject { ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='color'" }

    it "loads native format" do
      subject[ "Type" ].should == "enum('red','gold')"
    end

    it "loads default option" do
      subject[ "Default" ].should == "gold"
    end

    it "loads null option" do
      subject[ "Null" ].should == "NO"
    end

    it "loads native column format" do
      subject = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='size'"
      subject[ "Type" ].should == "enum('small','medium','large')"
    end
  end

  describe "validation" do
    it "validates assigned value is member of the list"
    it "allows nil when null enabled"
  end

  private
  def standard_dump
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end
end
