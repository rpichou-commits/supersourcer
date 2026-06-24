class Search < ApplicationRecord
  has_many :candidates, dependent: :destroy
end
