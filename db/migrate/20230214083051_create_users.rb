class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.text :token
      t.datetime :expire_at

      t.timestamps
    end
  end
end
