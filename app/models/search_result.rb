class SearchResult < ApplicationRecord
  belongs_to :search
  has_many :potential_candidates, dependent: :destroy
end
