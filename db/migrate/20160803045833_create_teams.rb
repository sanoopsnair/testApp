class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      
      t.string :name, :null => false, limit: 128
      t.string :designation, :null => false, limit: 256
      t.string :description, :null => false, limit: 256

      t.string :status, :null => false, :default=>"unpublished", :limit=>16

      t.timestamps null: false
    end
    add_index :teams, :status
  end
end
