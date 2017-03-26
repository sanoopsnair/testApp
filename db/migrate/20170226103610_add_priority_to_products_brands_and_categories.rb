class AddPriorityToProductsBrandsAndCategories < ActiveRecord::Migration[5.0]
  def change

  	add_column :categories, :priority, :integer, default: 1000
  	add_column :brands, :priority, :integer, default: 1000
  	add_column :products, :priority, :integer, default: 1000

  end
end
