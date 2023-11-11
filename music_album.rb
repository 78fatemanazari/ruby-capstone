# music_album.rb
require_relative 'item'

class MusicAlbum < Item
  attr_accessor :on_spotify, :title

  @next_id = 1

  class << self
    attr_accessor :next_id
  end

  def self.generate_unique_id
    @next_id += 1
  end

  def initialize(id, publish_date, title, on_spotify)
    super(id, publish_date)
    @title = title
    @on_spotify = on_spotify
  end

  def can_be_archived?
    super && on_spotify
  end

  def as_json(_options = {})
    {
      id: @id,
      publish_date: @publish_date,
      title: @title,
      on_spotify: @on_spotify
      # Add other attributes as needed
    }
  end
end
