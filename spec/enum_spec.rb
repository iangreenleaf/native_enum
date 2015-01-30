require 'spec_helper'

describe "ENUM datatype" do

  describe "schema dump", :db_support => true do
    before { load_schema "enum_old" }
    subject { dumped_schema }

    it "dumps native format" do
      expect(subject).to match %r{t\.enum\s+"color",\s+(:limit =>|limit:) \["blue", "red", "yellow"\]}
    end

    it "dumps default option" do
      expect(subject).to match %r{t\.enum\s+"color",.+(:default =>|default:) "red"}
    end

    it "dumps null option" do
      expect(subject).to match %r{t\.enum\s+"color",.+(:null =>|null:) false$}
    end
  end

  describe "schema loading" do
    before { load_schema "enum_new" }
    subject { column_props :balloons, :color }

    it "loads native format", :db_support => true do
      expect(subject[:type]).to eq("enum('red','gold')")
    end

    it "falls back to text when missing db support", :db_support => false do
      expect(subject[:type]).to match(/varchar/)
    end

    it "loads default option" do
      expect(subject[:default]).to eq("gold")
    end

    it "loads null option" do
      expect(subject[:null]).to eq(false)
    end

    it "loads native column format", :db_support => true do
      subject = column_props :balloons, :size
      expect(subject[:type]).to eq("enum('small','medium','large')")
    end
  end
end
