class RenameUsersToUsuaris < ActiveRecord::Migration[8.1]
  def change
    rename_table :users, :usuaris

    remove_index :usuaris, name: "index_users_on_lower_email", if_exists: true
    remove_index :usuaris, name: "index_usuaris_on_lower_email", if_exists: true
    remove_index :usuaris, name: "index_users_on_lower_username", if_exists: true
    remove_index :usuaris, name: "index_usuaris_on_lower_username", if_exists: true

    rename_column :usuaris, :username, :nom_usuari
    rename_column :usuaris, :password_digest, :contrasenya_digest
    rename_column :usuaris, :bio, :biografia
    rename_column :usuaris, :profile_image_url, :foto_perfil_url
    rename_column :usuaris, :language, :idioma
    rename_column :usuaris, :private_profile, :privacitat
    rename_column :usuaris, :notifications_enabled, :notificacions_actives
    rename_column :usuaris, :account_status, :estat_compte
    rename_column :usuaris, :role, :rol

    add_index :usuaris, "LOWER(email)", unique: true, name: "index_usuaris_on_lower_email"
    add_index :usuaris, "LOWER(nom_usuari)", unique: true, name: "index_usuaris_on_lower_nom_usuari"
  end
end
