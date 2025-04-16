class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :image
      t.integer :coins
      t.boolean :opt_in_email
      t.boolean :active

      t.timestamps
    end
  end
end
