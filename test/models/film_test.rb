require 'test_helper'

class FilmTest < ActiveSupport::TestCase  
  test "uniqueness of title" do
    film = films(:film1)
    assert_raises(ActiveRecord::RecordInvalid) { Film.create!(title: film.title) }
  end
  
  test "has url_slug on initialize" do
    film = Film.create!(title: "Blah wit da blah")
    assert_not_nil film
    assert_not_nil film.url_slug
  end
  
  test "add_related_film should add new film to existing related films" do
    film1 = films(:film1)
    film2 = films(:film2)
    film3 = films(:film3)
    film1.add_related_film(film2)
    assert_includes(film2.related_films, film1)
    film2.add_related_film(film3)
    assert_includes(film1.related_films, film3)
    [film1, film2, film3].each do |film|
      assert_equal(2, film.related_films.size)
    end
  end
  
end
