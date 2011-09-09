ActiveRecord::Schema.define do
  create_table :balloons, :force => true do |t|
    t.integer "id"
    t.set "ribbons", :limit => ['red', 'green', 'gold'], :default => ['green','gold'], :null => false
    t.column "gasses", :set, :limit => ['helium', 'hydrogen']
  end
end
