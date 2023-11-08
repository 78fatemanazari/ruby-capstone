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
    JSON.parse(File.read(filename)).map do |json|
      data_class.from_json(json)
    end
  else
    []
  end
end

books = load_data_from_json('books.json', Book)
labels = load_data_from_json('labels.json', Label)

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
    save_data_to_json('books.json', books)
    save_data_to_json('labels.json', labels)
    puts 'Data saved. Goodbye!'
    break
  else
    puts 'Invalid option. Please select a valid option.'
  end
end
