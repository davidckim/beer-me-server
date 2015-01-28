class AddDescriptionToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :desc, :text
  end
end
