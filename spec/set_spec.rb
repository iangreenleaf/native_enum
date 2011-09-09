require 'spec_helper'

describe "SET datatype" do

  describe "schema dump", :db_support => true do
    before { load_schema "set_old" }
    subject { dumped_schema }

    it "dumps native format" do
      subject.should match %r{t\.set\s+"gadgets",\s+:limit => \["propeller", "tail gun", "gps"\]}
    end

    it "dumps default option" do
      subject.should match %r{t\.set\s+"gadgets",.+:default => \["propeller", "gps"\]}
    end

    it "dumps null option" do
      subject.should match %r{t\.set\s+"gadgets",.+:null => false$}
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

  describe "assignment" do
    before { load_schema "set_new" }
    it "accepts single value" do
      b = Balloon.create :gasses => "helium"
      b.should be_valid
      b.reload.gasses.should == "helium"
    end
    it "accepts array of values", :db_support => true do
      b = Balloon.create :gasses => [ "helium", "hydrogen" ]
      b.should be_valid
      b.reload.gasses.should == "helium,hydrogen"
    end
    it "accepts comma-separated values" do
      b = Balloon.create :gasses => "helium,hydrogen"
      b.should be_valid
      b.reload.gasses.should == "helium,hydrogen"
    end
    it "accepts empty list", :db_support => true do
      b = Balloon.create :gasses => [ ]
      b.should be_valid
      b.reload.gasses.should == ""
    end
  end

  describe "getter" do
    before do
      load_schema "set_new"
      ActiveRecord::Base.connection.execute "INSERT INTO balloons (gasses) VALUES ('helium,hydrogen')"
      @b = Balloon.first
    end
    it "returns comma-separated values by default" do
      @b.gasses.should == "helium,hydrogen"
    end
    it "returns array of values when config option is set"
  end
end

class Balloon < ActiveRecord::Base; end
