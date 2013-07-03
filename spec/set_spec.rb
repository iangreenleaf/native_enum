require 'spec_helper'

describe "SET datatype" do

  describe "schema dump", :db_support => true do
    before { load_schema "set_old" }
    subject { dumped_schema }

    it "dumps native format" do
      subject.should match %r{t\.set\s+"gadgets",\s+(:limit =>|limit:) \["propeller", "tail gun", "gps"\]}
    end

    it "dumps default option" do
      subject.should match %r{t\.set\s+"gadgets",.+(:default =>|default:) \["propeller", "gps"\]}
    end

    it "dumps null option" do
      subject.should match %r{t\.set\s+"gadgets",.+(:null =>|null:) false$}
    end
  end

  describe "schema loading" do
    before { load_schema "set_new" }
    subject { column_props :balloons, :ribbons }

    it "loads native format", :db_support => true do
      subject[ :type ].should == "set('red','green','gold')"
    end

    it "falls back to text when missing db support", :db_support => false do
      subject[ :type ].should =~ /varchar/
    end

    it "loads default option" do
      subject[ :default ].should == "green,gold"
    end

    it "loads null option" do
      subject[ :null ].should be_false
    end

    it "loads native column format", :db_support => true do
      subject = column_props :balloons, :gasses
      subject[ :type ].should == "set('helium','hydrogen')"
    end
  end
end

class Balloon < ActiveRecord::Base; end
