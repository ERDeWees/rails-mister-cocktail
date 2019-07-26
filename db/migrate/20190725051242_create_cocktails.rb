class CreateCocktails < ActiveRecord::Migration[5.2]
  def change
    create_table :cocktails do |t|
      t.text :name
      t.text :description
      t.text :instructions

      t.timestamps
    end
  end
end
