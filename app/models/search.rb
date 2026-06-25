class Search < ApplicationRecord
  has_many :search_results, dependent: :destroy
  has_many :candidates, dependent: :destroy
  has_many :potential_candidates, through: :search_results
end
