class CreateTestimonials < ActiveRecord::Migration[5.0]
  def change
    create_table :testimonials do |t|
      
      t.string :name, :null => false, limit: 128
      t.string :designation, :null => false, limit: 256
      t.string :organisation, :null => false, limit: 256

      t.text   :statement

      t.string :status, :null => false, :default=>"unpublished", :limit=>16
      t.boolean :featured, default: false

      t.timestamps null: false
    end
    add_index :testimonials, :status
  end
end
