class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :shortUrl
      t.string :originalUrl
      t.integer :viewsCount

      t.timestamps
    end
  end
end
