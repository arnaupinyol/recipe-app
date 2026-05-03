class CreateRecipeDomainEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :alergies do |t|
      t.string :nom, null: false

      t.timestamps
    end
    add_index :alergies, "LOWER(nom)", unique: true, name: "index_alergies_on_lower_nom"

    create_table :categories do |t|
      t.string :nom, null: false
      t.text :descripcio

      t.timestamps
    end
    add_index :categories, "LOWER(nom)", unique: true, name: "index_categories_on_lower_nom"

    create_table :estris do |t|
      t.string :nom, null: false

      t.timestamps
    end
    add_index :estris, "LOWER(nom)", unique: true, name: "index_estris_on_lower_nom"

    create_table :ingredients do |t|
      t.string :nom, null: false
      t.text :descripcio_opcional
      t.string :foto_ingredient_url

      t.timestamps
    end
    add_index :ingredients, "LOWER(nom)", unique: true, name: "index_ingredients_on_lower_nom"

    create_table :llistes_compra do |t|
      t.references :usuari, null: false, foreign_key: true
      t.string :nom, null: false
      t.text :descripcio_opcional

      t.timestamps
    end

    create_table :receptes do |t|
      t.references :usuari, null: false, foreign_key: true
      t.string :titol, null: false
      t.text :descripcio
      t.integer :visibilitat, null: false, default: 0
      t.integer :temps_preparacio, null: false
      t.integer :dificultat, null: false
      t.integer :racions, null: false
      t.integer :likes, null: false, default: 0
      t.integer :guardats, null: false, default: 0
      t.boolean :pot_ser_ingredient, null: false, default: false

      t.timestamps
    end
    add_index :receptes, :visibilitat

    create_table :bloqueigs do |t|
      t.references :bloquejador, null: false, foreign_key: { to_table: :usuaris }
      t.references :bloquejat, null: false, foreign_key: { to_table: :usuaris }
      t.datetime :data_bloqueig, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
    add_index :bloqueigs, [:bloquejador_id, :bloquejat_id], unique: true

    create_table :seguiments do |t|
      t.references :seguidor, null: false, foreign_key: { to_table: :usuaris }
      t.references :seguit, null: false, foreign_key: { to_table: :usuaris }
      t.datetime :data_seguiment, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
    add_index :seguiments, [:seguidor_id, :seguit_id], unique: true

    create_table :usuaris_like_receptes do |t|
      t.references :usuari, null: false, foreign_key: true
      t.references :recepta, null: false, foreign_key: true

      t.timestamps
    end
    add_index :usuaris_like_receptes, [:usuari_id, :recepta_id], unique: true

    create_table :usuaris_guarda_receptes do |t|
      t.references :usuari, null: false, foreign_key: true
      t.references :recepta, null: false, foreign_key: true

      t.timestamps
    end
    add_index :usuaris_guarda_receptes, [:usuari_id, :recepta_id], unique: true

    create_table :comentaris do |t|
      t.references :usuari, null: false, foreign_key: true
      t.references :recepta, null: false, foreign_key: true
      t.text :text, null: false
      t.integer :valoracio, null: false

      t.timestamps
    end
    add_index :comentaris, [:usuari_id, :recepta_id], unique: true

    create_table :passos do |t|
      t.references :recepta, null: false, foreign_key: true
      t.integer :numero_ordre, null: false
      t.text :descripcio, null: false
      t.integer :temps_temporitzador_seg

      t.timestamps
    end
    add_index :passos, [:recepta_id, :numero_ordre], unique: true

    create_table :imatges_pas do |t|
      t.references :pas, null: false, foreign_key: { to_table: :passos }
      t.string :url, null: false

      t.timestamps
    end

    create_table :imatges_recepta do |t|
      t.references :recepta, null: false, foreign_key: true
      t.string :url, null: false

      t.timestamps
    end

    create_table :recepta_ingredients do |t|
      t.references :recepta, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :quantitat, precision: 10, scale: 2, null: false
      t.integer :tipus_racio, null: false
      t.text :observacions

      t.timestamps
    end
    add_index :recepta_ingredients, [:recepta_id, :ingredient_id], unique: true

    create_table :recepta_subreceptes do |t|
      t.references :recepta, null: false, foreign_key: true
      t.references :subrecepta, null: false, foreign_key: { to_table: :receptes }
      t.decimal :quantitat, precision: 10, scale: 2, null: false
      t.integer :tipus_racio, null: false
      t.text :observacions

      t.timestamps
    end
    add_index :recepta_subreceptes, [:recepta_id, :subrecepta_id], unique: true

    create_table :items_llista_compra do |t|
      t.references :llista_compra, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :quantitat, precision: 10, scale: 2, null: false
      t.integer :tipus_racio, null: false
      t.boolean :comprat, null: false, default: false

      t.timestamps
    end

    create_join_table :alergies, :ingredients,
                      table_name: :alergies_ingredients,
                      column_options: { null: false } do |t|
      t.index [:alergia_id, :ingredient_id], unique: true, name: "index_alergies_ingredients_on_ids"
      t.index [:ingredient_id, :alergia_id], name: "index_alergies_ingredients_on_reverse_ids"
    end
    add_foreign_key :alergies_ingredients, :alergies
    add_foreign_key :alergies_ingredients, :ingredients

    create_join_table :alergies, :usuaris,
                      table_name: :alergies_usuaris,
                      column_options: { null: false } do |t|
      t.index [:alergia_id, :usuari_id], unique: true, name: "index_alergies_usuaris_on_ids"
      t.index [:usuari_id, :alergia_id], name: "index_alergies_usuaris_on_reverse_ids"
    end
    add_foreign_key :alergies_usuaris, :alergies
    add_foreign_key :alergies_usuaris, :usuaris

    create_join_table :categories, :receptes,
                      table_name: :categories_receptes,
                      column_options: { null: false } do |t|
      t.index [:categoria_id, :recepta_id], unique: true, name: "index_categories_receptes_on_ids"
      t.index [:recepta_id, :categoria_id], name: "index_categories_receptes_on_reverse_ids"
    end
    add_foreign_key :categories_receptes, :categories
    add_foreign_key :categories_receptes, :receptes

    create_join_table :estris, :receptes,
                      table_name: :estris_receptes,
                      column_options: { null: false } do |t|
      t.index [:estri_id, :recepta_id], unique: true, name: "index_estris_receptes_on_ids"
      t.index [:recepta_id, :estri_id], name: "index_estris_receptes_on_reverse_ids"
    end
    add_foreign_key :estris_receptes, :estris
    add_foreign_key :estris_receptes, :receptes
  end
end
