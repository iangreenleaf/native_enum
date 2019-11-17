require 'spec_helper'

RSpec.describe "SET datatype" do

  describe "schema dump", :db_support => true do
    before { load_schema "set_old" }
    subject { dumped_schema }

    it "dumps native format" do
      expect(subject).to match %r{t\.set\s+"gadgets",\s+(:limit =>|limit:) \["propeller", "tail gun", "gps"\]}
    end

    it "dumps default option" do
      expect(subject).to match %r{t\.set\s+"gadgets",.+(:default =>|default:) \["propeller", "gps"\]}
    end

    it "dumps null option" do
      expect(subject).to match %r{t\.set\s+"gadgets",.+(:null =>|null:) false$}
    end
  end

  describe "schema loading" do
    before { load_schema "set_new" }
    subject { column_props :balloons, :ribbons }

    it "loads native format", :db_support => true do
      expect(subject[:type]).to eq("set('red','green','gold')")
    end

    it "falls back to text when missing db support", :db_support => false do
      expect(subject[:type]).to match(/varchar/)
    end

    it "loads default option" do
      expect(subject[:default]).to eq("green,gold")
    end

    it "loads null option" do
      expect(subject[:null]).to eq(false)
    end

    it "loads native column format", :db_support => true do
      subject = column_props :balloons, :gasses
      expect(subject[:type]).to eq("set('helium','hydrogen')")
    end
  end
end

class Balloon < ActiveRecord::Base; end
