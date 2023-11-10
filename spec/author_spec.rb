# spec/author_spec.rb

require_relative '../author'
require_relative '../game'

RSpec.describe Author do
  describe '#add_item' do
    it 'adds an item to the author and sets the author for the item' do
      author = Author.new(1, 'Stephen', 'King')
      game = Game.new(1, Time.new(2020, 1, 1), true, Time.new(2022, 1, 1))

      author.add_item(game)

      expect(author.items).to include(game)
      expect(game.authors).to include(author)
    end
  end
end
