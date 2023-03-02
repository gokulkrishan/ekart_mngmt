class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :prd_type
      t.string :style_name

      t.timestamps
    end
  end
end
