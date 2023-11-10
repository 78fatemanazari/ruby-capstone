require_relative 'item'
require 'date'

class Game < Item
  attr_accessor :multiplayer, :last_played_at, :publish_date

  def initialize(multiplayer, last_played_at, publish_date)
    super(published_date)
    @multiplayer = multiplayer
    @last_played_at = Date.parse(last_played_at)
  end

  private

  def can_be_archived?
    super && ((Date.today.year - @last_played_at.year).to_i > 2)
  end
end
