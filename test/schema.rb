ActiveRecord::Schema.define do
  create_table :aircraft, :force => true do |t|
    t.integer "id"
    t.column "color", "enum('blue','red','yellow')", :default => 'red', :null => false
  end
end
