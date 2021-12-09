class AddVendIdToSpreeUser < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_users, :vend_id, :string
    add_index :spree_users, :vend_id, unique: true
  end
end
