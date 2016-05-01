class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :image_url
      t.string :nickname

      t.timestamps null: false
    end
  end
end
