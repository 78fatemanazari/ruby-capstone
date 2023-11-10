# library.rb
require_relative '../item'
require_relative '../classes/Game'
require_relative '../classes/Author'
require 'json'

class Library
  def initialize
    @games = []
    @authors = []
  end

  def list_all_games
    @games.each do |game|
      puts "Game ID: #{game.id}, Title: #{game.title},
      Multiplayer: #{game.multiplayer}, Last Played: #{game.last_played_at}, Published Date: #{game.publish_date},
       Archived: #{game.archived}"
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
    load_items('games.json', Game)
    load_items('authors.json', Author)
  end

  private

  def load_items(filename, item_class)
    return unless File.exist?(filename)

    items_data = JSON.parse(File.read(filename))
    items = items_data.map { |data| item_class.from_hash(data) }
    instance_variable_set("@#{item_class.to_s.downcase}s", items)
  end
end
