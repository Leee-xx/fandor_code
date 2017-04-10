class FilmsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  FILM_FIELDS = %w(id title description url_slug year)
  SORT_KEYS = %w(id title year)
  
  before_action :make_fields
  
  def index
    count = params['count'] || -1
    offset = params['offset'] || 0
    sort_key = params['sort_key'] || "title"
    
    
    begin
      if count =~ /\D/
        raise "Invalid value for count"
      end
      if offset =~ /\D/
        raise "Invalid value for offset"
      end

      raise "Invalid value sort_key" if SORT_KEYS.exclude?(sort_key)
      
      films = Film.all.select(@fields).includes(:ratings).order(sort_key).limit(count).offset(offset)
      render json: films.map {|film| format_film_object(film)}
    rescue => ex
      render json: { error: ex.message }, status: 403
    end
  end
  
  def show
    film_id = params['id']
    
    film = Film.includes(:ratings).select(@fields).find(film_id)
    
    render json: format_film_object(film)
  end
  
  def rate
    score = params['score']
    begin
      film_id = params['id']
      film = Film.find(film_id)
      rating = Rating.create!(film: film, score: score)
      response = format_film_object(film)
    rescue => ex
      response = { error_message: ex.message }
    end
    render json: response
  end
  
  private
    def make_fields
      @fields = params['attributes']
      if @fields.present?
        @fields = @fields.split(/,/)
      else
        @fields = FILM_FIELDS
      end
      @fields = @fields.select {|field| field != "related_film_ids" && field != "average_rating"}.map {|field| field.to_sym}
    end
    
    def record_not_found
      render json: { error: "record not found" }, status: 404
    end
    
    def format_film_object(film)
      film_hash = film.attributes
      film_hash.delete("id")
      film_hash['related_film_ids'] = film.related_film_ids if params["attributes"].nil? || params["attributes"].include?("related_film_ids")
      film_hash['average_rating'] = film.average_rating().to_s if params["attributes"].nil? || params["attributes"].include?("average_rating")
      return film_hash
    end
end
