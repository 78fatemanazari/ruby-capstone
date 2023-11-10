require 'json'
require_relative 'item'
require_relative 'game'
require_relative 'author'
require 'date'
require 'json'
require_relative 'book'
require_relative 'label'

def display_menu
  puts 'Menu Options:'
  puts '1. Check if an item can be archived'
  puts '2. Move an item to the archive'
  puts '3. List all books'
  puts '4. List all labels'
  puts '5. Add a book'
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

def handle_option_three(books)
  puts 'List of all books:'
  books.each do |book|
    puts "#{book.title} by #{book.author} (Publisher: #{book.publisher}, Cover State: #{book.cover_state})"
  end
end

def handle_option_four(labels)
  puts 'List of all labels:'
  labels.each do |label|
    puts label.title
  end
end

def handle_option_five(books, labels)
  book_params = book_params(books)
  book = create_and_add_book(books, book_params)

  print 'Add a label for this book (y/n)? '
  add_label_option = gets.chomp.downcase

  if add_label_option == 'y'
    print 'Enter label title: '
    label_title = gets.chomp

    print 'Enter label color: '
    label_color = gets.chomp

    label = Label.new(generate_unique_id(labels), label_title, label_color)
    label.add_item(book)

    # Add the newly created label to the labels collection
    labels << label

    puts "Label '#{label.title}' added to '#{book.title}'."
  end

  puts "Book added: #{book.title} by #{book.author}"
end

def book_params(books)
  print 'Enter book title: '
  title = gets.chomp
  print 'Enter author: '
  author = gets.chomp
  print 'Enter cover state (good/bad): '
  cover_state = gets.chomp
  print 'Enter publisher: '
  publisher = gets.chomp

  {
    id: generate_unique_id(books),
    publish_date: generate_publish_date,
    title: title,
    author: author,
    cover_state: cover_state,
    publisher: publisher
  }
end

def create_and_add_book(books, params)
  book = Book.new(params)
  books << book
  book
end

def generate_unique_id(books)
  existing_ids = books.map(&:id)
  existing_ids.max.to_i + 1
end

def generate_publish_date
  Time.now
end

books = []
labels = []

def save_data_to_json(filename, data)
  File.open(filename, 'w') do |file|
    json_data = data.map(&:to_json)
    JSON.dump(json_data, file)
  end
end

def load_data_from_json(filename, data_class)
  if File.exist?(filename)
    JSON.parse(File.read(filename)).map { |json| data_class.from_json(json) }
  else
    []
  end
end

labels = load_data_from_json('labels.json', Label)
books = load_data_from_json('books.json', Book)

# Link labels with items
labels.each do |label|
  label.items = books.select { |book| book.label == label }
end

loop do
  display_menu
  print 'Please select an option: '
  choice = gets.chomp.to_i

  case choice
  when 1
    handle_option_one
  when 2
    handle_option_two
  when 3
    handle_option_three(books)
  when 4
    handle_option_four(labels)
  when 5
    handle_option_five(books, labels)
  when 9
    handle_option_nine(games)
  when 10
    handle_option_ten(authors)
  when 11
    handle_option_eleven(authors, games)
    save_data(authors, games)
  when 12
    save_data(authors, games)
    save_data_to_json('books.json', books)
    save_data_to_json('labels.json', labels)
    puts 'Data saved. Goodbye!'
    break
  else
    puts 'Invalid option. Please select a valid option.'
  end
end
