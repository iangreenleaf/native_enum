ActiveRecord::Schema.define do
  create_table :balloons, :force => true do |t|
    t.enum "color", :limit => ['red', 'gold'], :default => 'gold', :null => false
    t.column "size", :enum, :limit => ['small', 'medium', 'large']
  end
end
