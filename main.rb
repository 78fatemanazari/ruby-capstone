require 'json'
require_relative 'item'
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
  puts '9. Quit'
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
  print 'Enter item ID: '
  item_id = gets.chomp.to_i
  print 'Enter item publish year: '
  publish_year = gets.chomp.to_i

  item = Item.new(item_id, Time.new(publish_year, 1, 1))
  item.move_to_archive
  if item.archived
    puts 'Item has been moved to the archive.'
  else
    puts 'Item cannot be archived.'
  end
end

def handle_option_three(books)
  puts 'List of all books:'
  books.each do |book|
    puts "#{book.title} by #{book.author}"
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
  puts "Book added: #{book.title} by #{book.author}"

  print 'Add a label for this book (y/n)? '
  add_label_option = gets.chomp.downcase
  return unless add_label_option == 'y'

  print 'Enter label title: '
  label_title = gets.chomp
  label = Label.new(title: label_title, color: 'YourColorHere')
  labels << label
  book.add_label(label)
  puts "Label added: #{label.title}"
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
  puts "Music album added: #{album.title} - #{album.on_spotify ? 'On Spotify' : 'Not on Spotify'}"

  save_data_to_json(music_albums, MUSIC_ALBUMS_JSON_FILE)
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

def save_data_to_json(data, file_path)
  File.write(file_path, JSON.pretty_generate(data.map(&:as_json)))
end

def save_genres_to_json(genres)
  save_data_to_json(genres, GENRES_JSON_FILE)
end

books = load_data_from_json(BOOKS_JSON_FILE)
labels = load_data_from_json(LABELS_JSON_FILE)
music_albums = load_data_from_json(MUSIC_ALBUMS_JSON_FILE)
genres = load_data_from_json(GENRES_JSON_FILE)

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
    handle_option_five(books)
  when 6
    handle_option_six(music_albums)
  when 7
    handle_option_seven(music_albums, genres)
  when 8
    handle_option_eight(genres)
  when 9
    save_data_to_json(books, BOOKS_JSON_FILE)
    save_data_to_json(labels, LABELS_JSON_FILE)
    save_data_to_json(music_albums, MUSIC_ALBUMS_JSON_FILE)
    save_data_to_json(genres, GENRES_JSON_FILE)
    puts 'Data saved. Goodbye!'
    break
  else
    puts 'Invalid option. Please select a valid option.'
  end
end
