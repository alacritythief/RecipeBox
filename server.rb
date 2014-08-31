require 'pg'
require 'sinatra'

### METHODS ###

def connect
  begin
    connection = PG.connect(dbname: 'recipes')
    yield(connection)
  ensure
    connection.close
  end
end

def sql(query)
  connect do |conn|
    result = conn.exec_params(query)
  end
end

### ROUTES ###

get '/' do
  redirect '/recipes'
end

get '/recipes' do
  query = "SELECT name, MAX(id) FROM recipes GROUP BY name ORDER BY name"
  @recipes = sql(query)
  erb :recipes
end

get '/recipes/:id' do
  id = params[:id]

  ingredients = "
  SELECT ingredients.name FROM ingredients
  WHERE ingredients.recipe_id = #{id}"

  recipe = "
  SELECT name, instructions, description FROM recipes
  WHERE id = #{id}"

  @recipe = sql(recipe)
  @ingredients = sql(ingredients)

  erb :show
end





