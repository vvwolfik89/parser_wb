class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.integer :num
      t.integer :count
      t.text :body

      t.timestamps
    end
  end
end
