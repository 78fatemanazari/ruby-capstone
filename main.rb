require 'json'
require_relative 'item'
require_relative 'game'
require_relative 'author'
require 'date'
require_relative 'book'
require_relative 'label'
require_relative 'music_album'
require_relative 'genre'
def display_menu
  puts 'Menu Options:'
  puts '1. Check if an item can be archived'
  puts '2. Move an item to the archive'
  puts '3. List all books'
  puts '4. List all labels'
  puts '5. Add a book'
  puts '6. List all music albums'
  puts '7. Add a music album'
  puts '8. List all genres' # Added this line
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

def handle_option_six(music_albums)
  puts 'List of all music albums:'
  music_albums.each do |album|
    if album.is_a?(MusicAlbum)
      puts "#{album.title} - #{album.on_spotify ? 'On Spotify' : 'Not on Spotify'}"
    else
      puts "#{album.inspect} is not a valid MusicAlbum object."
    end
  end
end

def handle_option_seven(music_albums, genres)
  album_params = album_params(music_albums)
  album = create_and_add_music_album(music_albums, genres, album_params)

  if genres.empty?
    handle_no_genres_option(album, genres)
  else
    handle_with_genres_option(album, genres)
  end

  save_data_to_json(music_albums, MUSIC_ALBUMS_JSON_FILE)
  save_data_to_json(genres, GENRES_JSON_FILE)
end

def handle_no_genres_option(album, genres)
  puts 'No genres available. Would you like to add a new genre? (y/n)'
  add_new_genre_option = gets.chomp.downcase

  if add_new_genre_option == 'y'
    new_genre = create_and_add_genre(genres)
    puts "New genre added: #{new_genre.name}"
    new_genre.add_item(album)
    puts "Music album added to genre '#{new_genre.name}'."
  else
    puts 'No genre added. Music album not associated with any genre.'
  end
end

def handle_with_genres_option(album, genres)
  print 'Add a genre for this music album (y/n)? '
  add_genre_option = gets.chomp.downcase

  return unless add_genre_option == 'y'

  handle_genre_selection(album, genres)
end

def handle_genre_selection(album, genres)
  display_genres(genres)
  print 'Enter genre index or press 0 to add a new genre: '
  genre_index = gets.chomp.to_i - 1

  if genre_index.between?(0, genres.length - 1)
    selected_genre = genres[genre_index]
    selected_genre.add_item(album)
    puts "Music album added to genre '#{selected_genre.name}'."
  elsif genre_index == -1
    new_genre = create_and_add_genre(genres)
    puts "New genre added: #{new_genre.name}"
    new_genre.add_item(album)
    puts "Music album added to genre '#{new_genre.name}'."
  else
    puts 'Invalid genre index. Genre not added.'
  end
end

def create_and_add_genre(genres)
  print 'Enter genre name: '
  genre_name = gets.chomp

  new_genre = Genre.new(generate_unique_id(genres), genre_name)
  genres << new_genre
  new_genre
end

def handle_option_eight(genres)
  Genre.list_all_genres(genres)
end

def album_params(music_albums)
  print 'Enter album title: '
  title = gets.chomp
  print 'Enter release year: '
  release_year = gets.chomp.to_i
  print 'On Spotify? (y/n): '
  on_spotify_option = gets.chomp.downcase

  {
    id: generate_unique_id(music_albums),
    publish_date: Time.new(release_year, 1, 1),
    title: title,
    on_spotify: on_spotify_option == 'y'
  }
end

def create_and_add_music_album(music_albums, genres, params)
  album = MusicAlbum.new(
    params[:id],
    params[:publish_date],
    params[:title],
    params[:on_spotify]
  )
  music_albums << album
  genres.each { |genre| genre.add_item(album) } # Add the album to all genres
  album
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

def generate_unique_id(items)
  existing_ids = items.map { |item| item.id if item.respond_to?(:id) }.compact
  existing_ids.max.to_i + 1
end

def generate_publish_date
  Time.now
end

books = []
labels = []

GENRES_JSON_FILE = 'genres.json'.freeze
BOOKS_JSON_FILE = 'books.json'.freeze
LABELS_JSON_FILE = 'labels.json'.freeze
MUSIC_ALBUMS_JSON_FILE = 'music_albums.json'.freeze

def load_data_from_json(file_path)
  if File.exist?(file_path)
    data = JSON.parse(File.read(file_path), symbolize_names: true)
    data.map do |item_data|
      MusicAlbum.new(item_data[:id], item_data[:publish_date], item_data[:title], item_data[:on_spotify])
    end
  else
    []
  end
end

# def save_data_to_json(filename, data)
#   File.open(filename, 'w') do |file|
#     json_data = data.map(&:to_json)
#     JSON.dump(json_data, file)
#   end
# end

# def load_data_from_json(filename, data_class)
#   if File.exist?(filename)
#     JSON.parse(File.read(filename)).map { |json| data_class.from_json(json) }

#   else
#     []
#   end
# end

def save_data_to_json(data, file_path)
  File.write(file_path, JSON.pretty_generate(data.map { |item| item.respond_to?(:as_json) ? item.as_json : item }))
end

def save_genres_to_json(genres)
  save_data_to_json(genres, GENRES_JSON_FILE)
end

books = load_data_from_json(BOOKS_JSON_FILE)
labels = load_data_from_json(LABELS_JSON_FILE)
music_albums = load_data_from_json(MUSIC_ALBUMS_JSON_FILE)
genres = load_data_from_json(GENRES_JSON_FILE)

# labels = load_data_from_json('labels.json', Label)
# books = load_data_from_json('books.json', Book)

# # Link labels with items
# labels.each do |label|
#   label.items = books.select { |book| book.label == label }
# end

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
  when 6
    handle_option_six(music_albums)
  when 7
    handle_option_seven(music_albums, genres)
  when 8
    handle_option_eight(genres)
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
    save_data_to_json(books, BOOKS_JSON_FILE)
    save_data_to_json(labels, LABELS_JSON_FILE)
    save_data_to_json(music_albums, MUSIC_ALBUMS_JSON_FILE)
    save_data_to_json(genres, GENRES_JSON_FILE)
    #     save_data_to_json('books.json', books)
    #     save_data_to_json('labels.json', labels)
    puts 'Data saved. Goodbye!'
    break
  else
    puts 'Invalid option. Please select a valid option.'
  end
end
