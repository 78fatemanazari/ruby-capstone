require_relative 'item'
require_relative 'game'
require_relative 'author'
require 'date'
require 'json'

def display_menu
  puts 'Menu Options:'
  puts '1. Check if an item can be archived'
  puts '2. Move an item to the archive'
  puts '9. List all games'
  puts '10. List all authors'
  puts '11. Add a game'
  puts '12. Quit'
end

def handle_option_one
  print 'Enter item ID: '
  item_id = gets.chomp.to_i
  print 'Enter item publish year: '
  publish_year = gets.chomp.to_i

  item = Item.new(item_id, Time.new(publish_year, 1, 1))
  if item.can_be_archived?
    puts 'Item can be archived.'
  else
    puts 'Item cannot be archived.'
  end
end

def handle_option_two
  print 'Enter game ID: '
  game_id = gets.chomp.to_i
  print 'Enter game title: '
  game_title = gets.chomp
  print 'Enter game publish date and time (YYYY-MM-DD HH:MM:SS): '
  publish_date_time = gets.chomp

  # Parse publish_date_time to a DateTime object
  publish_date = DateTime.parse(publish_date_time)

  print 'Is the game multiplayer? (true/false): '
  multiplayer = gets.chomp.downcase == 'true'
  print 'Enter last played date and time (YYYY-MM-DD HH:MM:SS): '
  last_played_date = gets.chomp

  # Parse last_played_date to a DateTime object
  last_played_at = DateTime.parse(last_played_date)

  game = Game.new(game_id, game_title, publish_date, multiplayer, last_played_at)

  if game.can_be_archived?
    puts 'Game can be archived.'
  else
    puts 'Game cannot be archived.'
  end
end

def handle_option_nine(games)
  puts 'List of Games:'
  games.each do |game|
    puts "ID: #{game.id}, Title: #{game.title},
     Published Year: #{game.publish_date}, Multiplayer: #{game.multiplayer}, Last Played At: #{game.last_played_at}"
  end
end

def handle_option_ten(authors)
  puts 'List of Authors:'
  authors.each do |author|
    puts "ID: #{author.id}, Name: #{author.first_name} #{author.last_name}"
    author.items.each do |item|
      puts "  Item ID: #{item.id}, Title: #{item.id}" # Using the 'id' attribute
    end
  end
end

# ...

def handle_option_eleven(authors, games)
  game = create_game_from_user_input

  loop do
    add_author_to_game(authors, game)
    break unless user_wants_to_add_author?
  end

  games << game

  puts 'Game added successfully.'
end

def load_data
  authors_data, games_data = load_json_data

  authors = create_authors(authors_data)
  games = create_games(games_data)

  [authors, games]
end

def load_json_data
  authors_data = load_data_from_json_file('authors.json')
  games_data = load_data_from_json_file('games.json')

  [authors_data, games_data]
end

def load_data_from_json_file(file_name)
  JSON.parse(File.read(file_name), symbolize_names: true)
rescue StandardError
  []
end

def create_authors(authors_data)
  authors_data.map do |author_data|
    create_author_from_data(author_data)
  end
end

def create_games(games_data)
  games_data.map do |game_data|
    create_game_from_data(game_data)
  end
end

def create_author_from_data(author_data)
  author = Author.new(author_data[:id], author_data[:first_name], author_data[:last_name])
  author_data[:items].each { |item_data| author.add_item(Item.new(item_data[:id], item_data[:publish_date])) }
  author
end

def create_game_from_data(game_data)
  Game.new(
    game_data[:id],
    game_data[:title],
    game_data[:publish_date],
    game_data[:multiplayer],
    game_data[:last_played_at]
  )
end

def create_game_from_user_input
  print 'Enter game ID: '
  game_id = gets.chomp.to_i
  print 'Enter game title: '
  game_title = gets.chomp
  print 'Enter game publish date and time (YYYY-MM-DD HH:MM:SS): '
  publish_date_time = gets.chomp
  publish_date = parse_date_from_user_input(publish_date_time)

  print 'Is the game multiplayer? (true/false): '
  multiplayer = gets.chomp.downcase == 'true'
  print 'Enter last played date and time (YYYY-MM-DD HH:MM:SS): '
  last_played_date_time = gets.chomp
  last_played_at = parse_date_from_user_input(last_played_date_time)

  Game.new(game_id, game_title, publish_date, multiplayer, last_played_at)
end

def parse_date_from_user_input(date_string)
  DateTime.parse(date_string)
rescue ArgumentError
  puts 'Invalid date and time format. Please enter in the correct format (YYYY-MM-DD HH:MM:SS).'
  retry
end

def add_author_to_game(authors, game)
  print 'Enter author ID (or 0 to add a new author): '
  author_id = gets.chomp.to_i

  if author_id.zero?
    create_and_add_new_author(authors, game)
  else
    existing_author = authors.find { |a| a.id == author_id }
    handle_existing_author(existing_author, game)
  end
end

def create_and_add_new_author(authors, game)
  author = create_author_from_user_input(authors)
  game.add_author(author)
  author.add_item(game)
  puts 'Author added to the game.'
end

def create_author_from_user_input(authors)
  print 'Enter author first name: '
  first_name = gets.chomp
  print 'Enter author last name: '
  last_name = gets.chomp

  author = Author.new(authors.length + 1, first_name, last_name)
  authors << author
  author
end

def handle_existing_author(existing_author, game)
  unless existing_author
    puts 'Author not found. Please add the author first.'
    return
  end

  game.add_author(existing_author)
  existing_author.add_item(game)
  puts 'Author added to the game.'
end

def user_wants_to_add_author?
  print 'Do you want to add another author to the game? (yes/no): '
  gets.chomp.downcase == 'yes'
end

def save_data(authors, games)
  # Save authors and games data to JSON files
  File.write('authors.json', JSON.dump(authors.map(&:to_h)))
  File.write('games.json', JSON.dump(games.map(&:to_h)))
end

authors, games = load_data

loop do
  display_menu
  print 'Please select an option: '
  choice = gets.chomp.to_i

  case choice
  when 1
    handle_option_one
  when 2
    handle_option_two
  when 9
    handle_option_nine(games)
  when 10
    handle_option_ten(authors)
  when 11
    handle_option_eleven(authors, games)
    save_data(authors, games)
  when 12
    puts 'Goodbye!'
    save_data(authors, games)
    break
  else
    puts 'Invalid option. Please select a valid option.'
  end
end
