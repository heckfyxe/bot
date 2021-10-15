class AddPlaceToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :place, :integer
  end
end
