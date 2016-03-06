class CreateDistributions < ActiveRecord::Migration
  def change
    create_table :distributions do |t|
      t.string :title
      t.text :body
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
