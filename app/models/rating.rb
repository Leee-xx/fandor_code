class Rating < ApplicationRecord
  belongs_to :film
  
  validates :score, numericality: {
    less_than_or_equal_to: 10,
    greater_than_or_equal_to: 0,
   }
  
end
