require_relative '../game'
requuire 'rspec'
RSpec.describe Game do
  describe '#can_be_archived?' do
    it 'returns true if parent method returns true and last_played_at is older than 2 years' do
      game = Game.new(1, Time.new(2010, 1, 1), true, Time.now - (2.5 * 365 * 24 * 60 * 60))

      expect(game.can_be_archived?).to be(true)
    end

    it 'returns false if parent method returns false' do
      game = Game.new(1, Time.new(2022, 1, 1), true, Time.now)

      expect(game.can_be_archived?).to be(false)
    end

    it 'returns false if last_played_at is not older than 2 years' do
      game = Game.new(1, Time.new(2010, 1, 1), true, Time.now)

      expect(game.can_be_archived?).to be(false)
    end
  end
end
