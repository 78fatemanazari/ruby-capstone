require_relative 'item'
require 'date'

class Game < Item
  attr_accessor :multiplayer, :last_played_at
  attr_reader :title

  def initialize(id, title, publish_date, multiplayer, last_played_at)
    super(id, publish_date.to_s) # Convert DateTime to string using to_s
    @title = title
    @multiplayer = multiplayer
    @last_played_at = last_played_at
  end

  def can_be_archived?
    super && (Time.now - @last_played_at) > 2 * 365 * 24 * 60 * 60
  end

  def to_h
    super.merge(
      title: @title,
      multiplayer: @multiplayer,
      last_played_at: @last_played_at
    )
  end
end
