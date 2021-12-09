class AddVendIdToSpreeVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_variants, :vend_id, :string
    add_index :spree_variants, :vend_id, unique: true
  end
end
