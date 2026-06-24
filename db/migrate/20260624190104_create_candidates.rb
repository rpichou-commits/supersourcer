class CreateCandidates < ActiveRecord::Migration[8.1]
  def change
    create_table :candidates do |t|
      t.string :full_name
      t.text :summary
      t.string :linkedin_profile
      t.string :github_profile
      t.references :search, null: false, foreign_key: true

      t.timestamps
    end
  end
end
