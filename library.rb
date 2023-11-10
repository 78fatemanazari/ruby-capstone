require_relative 'item'
require_relative 'classes/game'
require_relative 'classes/author'
require 'date'
require 'json'

class Library
  def initialize
    @games = []
    @authors = []
  end

  def list_all_games
    @games.each do |game|
      puts "Game ID: #{game.id}, Title: #{game.title}, Multiplayer: #{game.multiplayer},
       Last Played: #{game.last_played_at}, Published Date: #{game.publish_date}, Archived: #{game.archived}"
    end
  end

  def list_all_authors
    @authors.each do |author|
      puts "Author ID: #{author.id}, Name: #{author.first_name} #{author.last_name}"
    end
  end

  def add_game
    puts 'Enter game details:'
    print 'Title: '
    title = gets.chomp
    print 'Multiplayer (true/false): '
    multiplayer = gets.chomp.downcase == 'true'
    print 'Last Played Date (YYYY-MM-DD): '
    last_played_at = Date.parse(gets.chomp)
    print 'Publish Date (YYYY-MM-DD): '
    publish_date = Date.parse(gets.chomp)

    new_game = Game.new(title, multiplayer, last_played_at, publish_date)
    @games << new_game

    puts "Game '#{new_game.title}' added successfully!"
  end

  def add_author(first_name, last_name)
    new_author = Author.new(first_name, last_name)
    @authors << new_author
    puts "Author '#{new_author.first_name} #{new_author.last_name}' added successfully!"
  end

  def save_data_to_json
    File.open('games.json', 'w') do |file|
      file.puts JSON.generate(@games.map(&:to_hash))
    end

    File.open('authors.json', 'w') do |file|
      file.puts JSON.generate(@authors.map(&:to_hash))
    end
  end

  def load_data_from_json
    if File.exist?('games.json')
      games_data = JSON.parse(File.read('games.json'))
      @games = games_data.map { |data| Game.from_hash(data) }
    end

    return unless File.exist?('authors.json')

    authors_data = JSON.parse(File.read('authors.json'))
    @authors = authors_data.map { |data| Author.from_hash(data) }
  end
end

# Example Usage
library = Library.new
library.load_data_from_json # Load data from JSON files if they exist

# Menu Loop
loop do
  puts '1. List all games'
  puts '2. List all authors'
  puts '3. Add a game'
  puts '4. Quit'
  print 'Choose an option: '
  choice = gets.chomp.to_i

  case choice
  when 1
    library.list_all_games
  when 2
    library.list_all_authors
  when 3
    library.add_game
  when 4
    library.save_data_to_json # Save data to JSON files before quitting
    puts 'Exiting the program. Goodbye!'
    break
  else
    puts 'Invalid option. Please choose a valid option.'
  end
end
