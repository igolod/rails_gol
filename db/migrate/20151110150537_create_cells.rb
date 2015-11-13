class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer :x
      t.integer :y
      t.boolean :dead, default: true
      t.references :life, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
