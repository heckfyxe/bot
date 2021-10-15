class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.column :nickname, :string, unique: true
      t.column :firstname, :string
      t.column :lastname, :string

      t.timestamps
    end
  end
end
