ActiveRecord::Schema.define do
  create_table :aircraft, :force => true do |t|
    t.string :name
  end
end
