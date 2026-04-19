class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.text :bio
      t.string :profile_image_url
      t.string :language, null: false, default: "ca"
      t.boolean :private_profile, null: false, default: false
      t.boolean :notifications_enabled, null: false, default: true
      t.integer :account_status, null: false, default: 0
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :users, "LOWER(email)", unique: true, name: "index_users_on_lower_email"
    add_index :users, "LOWER(username)", unique: true, name: "index_users_on_lower_username"
  end
end
