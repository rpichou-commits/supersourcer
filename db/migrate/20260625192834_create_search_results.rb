class CreateSearchResults < ActiveRecord::Migration[8.1]
  def change
    create_table :search_results do |t|
      t.references :search, null: false, foreign_key: true
      t.text :query
      t.json :raw_response
      t.string :status

      t.timestamps
    end
  end
end
