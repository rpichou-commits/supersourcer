class PotentialCandidate < ApplicationRecord
  belongs_to :search_result
  has_one :search, through: :search_result
end
