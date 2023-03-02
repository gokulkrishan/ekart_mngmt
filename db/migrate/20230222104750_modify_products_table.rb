class ModifyProductsTable < ActiveRecord::Migration[7.0]
  def change
    change_table :products do |t|
      t.change :style_name, :string, after: :prd_type
    end
  end
end
