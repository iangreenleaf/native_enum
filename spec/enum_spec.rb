require 'spec_helper'

describe "ENUM datatype" do

  describe "schema dump", :db_support => true do
    before { load_schema "enum_old" }
    subject { dumped_schema }

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

    it "loads native format", :db_support => true do
      subject[ "Type" ].should == "enum('red','gold')"
    end

    it "loads default option" do
      subject[ "Default" ].should == "gold"
    end

    it "loads null option" do
      subject[ "Null" ].should == "NO"
    end

    it "loads native column format", :db_support => true do
      subject = ActiveRecord::Base.connection.select_one "SHOW FIELDS FROM balloons WHERE Field='size'"
      subject[ "Type" ].should == "enum('small','medium','large')"
    end
  end
end
