class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      
      t.string :name, :null => false, limit: 128
      t.string :permalink, :null => false, limit: 128
      t.string :one_liner
      t.text   :description

      t.references :brand
      t.references :category
      t.references :top_category

      t.string :status, :null => false, :default=>"unpublished", :limit=>16
      t.boolean :featured, default: false

      t.timestamps null: false
    end

    add_index :products, :permalink, :unique => true
    add_index :products, :status
  end
end
