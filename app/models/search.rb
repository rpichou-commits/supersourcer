class Search < ApplicationRecord
  has_many :search_results, dependent: :destroy
  has_many :candidates, dependent: :destroy
end
