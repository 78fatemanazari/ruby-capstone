require 'json'


def loadgame
  games = []
  return games if File.empty?('json/game.json')

  gamesdata = File.read('json/game.json')
  gamesarray = JSON.parse(gamesdata)
  gamesarray.each do |game|
    newgame = Game.new(game['multiplayer'], game['last_played_at'], game['publishe_date'])
    genre = Genre.new(game['genre'])
    author = Author.new(game['first_name'], game['last_name'])
    newgame.genre = genre
    newgame.author = author
    games << newgame
  end
  games
end