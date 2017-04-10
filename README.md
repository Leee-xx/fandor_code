# README

RUBY VERSION
ruby 2.2.6p396 (2016-11-15 revision 56800)

RAILS VERSION
Rails 5.0.2

DEPLOYMENT
1. Clone from github
2. cd into project folder
3. rake db:migrate
4. rake db:seed
5. Enable web server


ENDPOINTS

GET /films
description: Gets a list of all films.
parameters (all optional):
  limit
    description: how many films to return
  offset
    description: begin the list at the nth offset
  attributes
    description: fields to return in the response; response has all fields if no attributes are specified
    enum:
      - id
      - title
      - description
      - url_slug
      - year
      - related_film_ids
      - average_score
  sort_key
    description: how to sort the response
    enum: - title
          - id
          - year

GET /films/{id}
description: Gets the specified film by its internal ID
parameters:
  id
    description: internal ID of the film.
    required: true
  attributes
    description: fields to return in the response; response has all fields if no attributes are specified
    enum:
      - id
      - title
      - description
      - url_slug
      - year
      - related_film_ids
      - average_score

POST /films/{id}/rate
description: allow a user to rate a certain film
parameters:
  score
    description: an integer score
    required: true
    in: body