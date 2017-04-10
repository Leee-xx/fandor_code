class FilmRelation < ApplicationRecord
  belongs_to :related_film, foreign_key: 'related_id', class_name: 'Film'
  belongs_to :relating_film, foreign_key: 'relating_id', class_name: 'Film'
  
  after_create :add_inverse
  after_update :update_inverse
  after_destroy :destroy_inverse
  
  def add_inverse
    self.class.find_or_create_by(related_id: relating_id, relating_id: related_id)
  end
  
  def update_inverse
    if changed?
      # inverse = self.class.where(related_id: relating_id_was)
      # inverse.update_attributes(related_id: relating_id, relating_id: related_id) if inverse
      # inverse = self.class.find(relating_id: related_id_was)
      # inverse.update_attributes(related_id: relating_id, relating_id: related_id) if inverse
      self.class.find(relating_id: related_id_was, related_id: relating_id_was)
      inverse.update_attributes(related_id: relating_id, relating_id: related_id) if inverse
    end
  end
  
  def destroy_inverse
    inverse = self.class.find(related_id: relating_id, relating_id: related_id)
    inverse.destroy if inverse && !inverse.destroyed?
  end
end
