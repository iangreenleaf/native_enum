ActiveRecord::Schema.define do
  create_table :aircraft, :force => true do |t|
    t.column "gadgets", "set('propeller','tail gun','gps')", :default => 'propeller,gps', :null => false
  end
end
