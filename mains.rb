# main.rb
require_relative 'modules/library'

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
    library.list_all('games')
  when 2
    library.list_all('authors')
  when 3
    library.add_game('game')
  when 4
    library.save_data_to_json # Save data to JSON files before quitting
    puts 'Exiting the program. Goodbye!'
    break
  else
    puts 'Invalid option. Please choose a valid option.'
  end
end
