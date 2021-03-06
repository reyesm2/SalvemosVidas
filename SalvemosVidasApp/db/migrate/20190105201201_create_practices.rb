class CreatePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practices do |t|
      t.string :title
      t.string :category
      t.string :description
      t.references :lesson, foreign_key: true

      t.timestamps
    end
  end
end
