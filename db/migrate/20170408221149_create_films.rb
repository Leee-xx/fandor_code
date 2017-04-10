class CreateFilms < ActiveRecord::Migration[5.0]
  def change
    create_table :films do |t|
      t.string :title, uniqueness: true, index: true
      t.text :description
      t.string :url_slug
      t.string :year
      t.string :related_film_ids, default: [].to_yaml, array: true
      t.timestamps
    end
  end
end
