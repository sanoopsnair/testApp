class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|

      ## First Name, Last Name and Username
      t.string :name, limit: 256
      t.string :username, :null => false, :limit=>32
      t.string :email, :null => false
      t.string :phone, :null => true, :limit=>24
      t.string :designation, :null => true, :limit=>56

      t.boolean :super_admin, :null => true, default: false

      t.string :status, :null => false, :default=>"inactive", :limit=>16

      ## Password Digest
      t.string :password_digest, :null => false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Token authenticatable
      t.string :auth_token
      t.datetime :token_created_at, default: nil

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :auth_token,           :unique => true
  end
end
