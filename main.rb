require 'json'
require_relative 'item'
require_relative 'book'
require_relative 'label'

def display_menu
  puts 'Menu Options:'
  puts '1. Check if an item can be archived'
  puts '2. Move an item to the archive'
  puts '3. List all books'
  puts '4. List all labels'
  puts '5. Add a book'
  puts '6. Quit'
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

def book_params(books)
  print 'Enter book title: '
  title = gets
    .chomp
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

BOOKS_JSON_FILE = 'books.json'.freeze
LABELS_JSON_FILE = 'labels.json'.freeze

def load_data_from_json(file_path)
  if File.exist?(file_path)
    JSON.parse(File.read(file_path), symbolize_names: true)
  else
    []
  end
end

def save_data_to_json(data, file_path)
  File.write(file_path, JSON.pretty_generate(data))
end

books = load_data_from_json(BOOKS_JSON_FILE)
labels = load_data_from_json(LABELS_JSON_FILE)

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
    # Save data to JSON files before quitting
    save_data_to_json(books, BOOKS_JSON_FILE)
    save_data_to_json(labels, LABELS_JSON_FILE)
    puts 'Data saved. Goodbye!'
    break
  else
    puts 'Invalid option. Please select a valid option.'
  end
end
