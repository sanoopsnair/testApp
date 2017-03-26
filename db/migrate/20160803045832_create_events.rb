class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title, :null => false, limit: 512
      t.string :permalink, :null => false, :limit=>32
      t.string :venue, :null => false, limit: 256
      t.text   :description1
      t.text   :description2
      t.text   :description3

      t.datetime :starts_at, :null => true
      t.datetime :ends_at, :null => true

      t.boolean  :news, default: true
      t.date     :news_date, :null => true

      t.boolean :featured, default: false
      t.string :status, :null => false, :default=>"unpublished", :limit=>16

      t.timestamps null: false
    end
    add_index :events, :permalink, unique: true
    add_index :events, :status
  end
end
