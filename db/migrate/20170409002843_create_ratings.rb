class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :film_id, index: true
      t.integer :score
      t.timestamps
    end
  end
end
