class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      
      t.string :name, :null => false, limit: 128
      t.string :one_liner
      t.string :permalink, :null => false, limit: 128
      t.text   :description
      t.references :parent, references: :category
      t.references :top_parent, references: :category
      
      t.string :status, :null => false, :default=>"unpublished", :limit=>16
      t.boolean :featured, default: false

      t.timestamps null: false
    end

    add_index :categories, :permalink, :unique => true
    add_index :categories, :status
  end
end
