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
    subject { column_props :balloons, :color }

    it "loads native format", :db_support => true do
      subject[ :type ].should == "enum('red','gold')"
    end

    it "falls back to text when missing db support", :db_support => false do
      subject[ :type ].should =~ /varchar/
    end

    it "loads default option" do
      subject[ :default ].should == "gold"
    end

    it "loads null option" do
      subject[ :null ].should be_false
    end

    it "loads native column format", :db_support => true do
      subject = column_props :balloons, :size
      subject[ :type ].should == "enum('small','medium','large')"
    end
  end
end
