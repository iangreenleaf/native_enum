ActiveRecord::Schema.define do
  create_table :balloons, :force => true do |t|
    t.integer "id"
    t.enum "color", :limit => ['red', 'gold'], :default => 'gold', :null => false
  end
end
