
def search_complex_search
  parsed_hash = JSON.parse(Faraday.get("https://api.spoonacular.com/recipes/complexSearch?apiKey=945916246cc3460dbfe56c71616e4d96&query=tuna").body)
  content = parsed_hash["recipes"]
  @results = {}
  @results[:name] = content[0]["title"] # returns string
  @results[:serves] = content[0]['servings']
  @results[:description] = content[0]['summary'].gsub(/<\/?[^>]+>/, '')
  @results[:recipe] = content[0]["instructions"].gsub(/<\/?[^>]+>/, '').gsub("\n", '') # returns string
  @results[:time_to_cook] = content[0]["readyInMinutes"] # returns integer, turn to stirng if needed?
  @results[:url] = content[0]['sourceUrl']
  @results
en