require_relative 'item'

def display_menu
  puts 'Menu Options:'
  puts '1. Check if an item can be archived'
  puts '2. Move an item to the archive'
  puts '3. Quit'
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
    puts 'Goodbye!'
    break
  else
    puts 'Invalid option. Please select a valid option.'
  end
end
