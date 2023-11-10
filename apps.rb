
require_relative 'classes/item'
require_relative 'classes/author'
require_relative 'classes/game'
require_relative 'storedata'
require_relative 'loaddata'
require 'securerandom'
require 'date'

class App
  def initialize
    @games = loadgame
    @authors = loadauthor
  end

  def run(option) 
    case option
    when 1
      list_games
    when 1
      list_genres
    when 3
      list_labels
    when 4
      list_authors
    when 5
      add_game
    when 6
      exit_app
    else
      puts 'Invalid option'
    end
  end





  def list_games
    puts 'No games in the library!' if @games.empty?
    @games.each_with_index do |game, index|
      puts "#{index + 1} | #{game.label.title} | Genre: #{game.genre.name} | Last Played: #{game.last_played_at}"
    end
  end

  def list_authors
    puts 'No authors in the library' if @authors.empty?
    @authors.each_with_index do |author, index|
      puts "#{index + 1} | #{author.first_name} #{author.last_name}"
    end
  end

  def add_game
    genre = Genre.new(user_input("Enter game's Genre: "))
    label = Label.new(user_input('Enter game Title/label: '), SecureRandom.hex(3))
    puts "Enter game's Director/Author"
    first_name = user_input('First name: ')
    last_name = user_input('Last name: ')
    author = Author.new(first_name, last_name)
    multiplayer = user_input('Does the game has multiplayer option[true/false]: ')
    last_played_at = user_input('Last played[yyyy-mm-dd]: ')
    published_date = user_input('Release date[yyyy-mm-dd]: ')
    game = Game.new(multiplayer, last_played_at, publish_date)
    genre.add_item(game)
    label.add_item(game)
    author.add_item(game)
    @games << game
    @genres << genre
    @labels << label
    @authors << author
    puts 'Game added successfully'
  end

  def exit_app
    store_author(@authors)
    store_books(@books)
    store_games(@games)
    puts 'Thank you for using the app. Goodbye!'
    exit
  end
end
