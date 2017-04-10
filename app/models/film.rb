class Film < ApplicationRecord
  has_many :film_relateds, foreign_key: :relating_id, class_name: 'FilmRelation'
  has_many :related_films, through: :film_relateds, source: :related_film
  
  has_many :film_relatings, foreign_key: :related_id, class_name: 'FilmRelation'
  has_many :relating_films, through: :film_relatings, source: :relating_film
  
  has_many :ratings
  validates :title, uniqueness: true
  serialize :related_film_ids

  def average_rating
    num_ratings = ratings.size
    return num_ratings.zero? ? 0.0 : ratings.sum(&:score).to_d / num_ratings
  end
  
  def add_related_film(film)
    if self.related_films.exclude?(film)
      self.related_films << film
      self.save!
    end
  end

  def self.to_slug(name)
   slug_name = name.strip.downcase.gsub(/\s+/, "_")
   slug_name.gsub!(/[^A-Za-z0-9_]/, '')
   return slug_name
  end
end
