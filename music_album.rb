# music_album.rb
require_relative 'item'

class MusicAlbum < Item
  attr_accessor :on_spotify, :title

  def initialize(id, publish_date, title, on_spotify)
    super(id, publish_date)
    @title = title
    @on_spotify = on_spotify
  end

  def can_be_archived?
    super && on_spotify
  end
end
