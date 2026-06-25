class CreatePotentialCandidates < ActiveRecord::Migration[8.1]
  def change
    create_table :potential_candidates do |t|
      t.string :full_name
      t.text :summary
      t.string :linkedin_url
      t.string :github_url
      t.string :source_url
      t.references :search_result, null: false, foreign_key: true

      t.timestamps
    end
  end
end
