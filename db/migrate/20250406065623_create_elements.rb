class CreateElements < ActiveRecord::Migration[8.0]
  def change
    create_table :elements do |t|
      t.integer :post_id
      t.string :title
      t.string :uri
      t.integer :created
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
    end
  end
end
