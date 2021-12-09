class AddVendIdToSpreeProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :vend_id, :string
    add_index :spree_products, :vend_id, unique: true
  end
end
