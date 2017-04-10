# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

movie_names = ["Foo Bar Baz", "2 Muskateers", "In the Skin of a Lion", "Mrs. Dalloway", "Ulysses", "Absalom! Absalom!"]
films = movie_names.map do |name|
  film = Film.find_or_create_by(title: name) do |film|
    film.description = "Description for #{name}"
    film.year = rand(15) + 2000
    film.url_slug = Film.to_slug(name)
  end
end

films.first.add_related_film(films.last)