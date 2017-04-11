require 'test_helper'

class FilmsControllerTest < ActionDispatch::IntegrationTest
  
  def parse_body
    JSON.parse(@response.body)
  end
  
  def call_index(params = {})
    get "/films", params: params
    assert_response :success
    parse_body()
  end
  
  test "index" do
    body = call_index()
    assert_equal(3, body.size)
  end
  
  test "index sort keys" do
    FilmsController::SORT_KEYS.each do |sort_key|
      body = call_index(sort_key: sort_key)
      prev_value = body.first[sort_key]
      body.slice(1, body.size - 1).each do |film_hash|
        assert(film_hash[sort_key] > prev_value)
        prev_value = film_hash[sort_key]
      end
    end
  end
  
  test "index attribute parameters" do
    all_response_fields = %w(title description url_slug year related_film_ids average_rating)
    body = call_index()
    film_hash = body.first
    assert(film_hash.keys == all_response_fields)

    keys_to_check = %w(average_rating related_film_ids title)
    keys_to_check.each do |attribute|
      body = call_index(attributes: attribute)
      assert(body.first.keys == [attribute])
     end

     body = call_index(attributes: keys_to_check.join(","))
     assert(body.first.keys.sort == keys_to_check.sort)
  end
      
  test "show" do
    film1 = films(:film1)
    
    get "/films/#{film1.id}"
    assert_response :success
  end
  

  test "Film.average_score should update" do
    film1 = films(:film1)
    assert_not_nil film1
    
    patch "/films/#{film1.id}/rate", params: { score: 8 }
    assert_response :success
    assert_equal(8, film1.average_rating)
    patch "/films/#{film1.id}/rate", params: { score: 9 }
    film1.reload
    assert_equal(8.5, film1.average_rating)
  end
  
end