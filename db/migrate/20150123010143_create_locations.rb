class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
    	t.string :name
    	t.string :address
    	t.integer :zip_code
    end
  end
end


