class AddSkuToProducts < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :sku, :string, limit: 128
  	add_index :products, :sku, :unique => true
  end
end
