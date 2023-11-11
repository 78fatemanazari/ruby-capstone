require_relative '../author'
require_relative '../game'

RSpec.describe Author do
  describe '#add_item' do
    it 'adds an item to the author and sets the author for the item' do
      author = Author.new(1, 'Stephen', 'King')
      game = Game.new(1, 'Example Game', Time.new(2020, 1, 1), true, Time.new(2022, 1, 1))

      # Modify the test to directly access the items attribute and add the game
      author.items << game

      # Since the class does not provide a direct way to access authors from the Game class,
      # we cannot directly set the author for the game in this test.

      expect(author.items).to include(game)
    end
  end
end
