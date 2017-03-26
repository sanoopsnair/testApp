class CreateEnquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :enquiries do |t|
      
      t.string :name, :null => false, limit: 128
      t.string :email, :null => false, limit: 256
      t.string :phone, :null => false, limit: 24

      t.string :subject, :null => false, limit: 256
      
      t.text   :message

      t.string :status, :null => false, :default=>"unread", :limit=>16

      t.timestamps null: false
    end
  end
end
