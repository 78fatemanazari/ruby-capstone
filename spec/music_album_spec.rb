# music_album_spec.rb

require_relative '../music_album'

RSpec.describe MusicAlbum do
  let(:music_album) { MusicAlbum.new(1, Time.new(2010, 1, 1), 'Some Title', true) }

  it 'can be archived if on Spotify and older than 10 years' do
    expect(music_album.can_be_archived?).to be(true)
  end

  it 'cannot be archived if not on Spotify' do
    music_album = MusicAlbum.new(2, Time.new(2010, 1, 1), 'Another Title', false)
    expect(music_album.can_be_archived?).to be(false)
  end

  it 'cannot be archived if less than 10 years old' do
    music_album = MusicAlbum.new(3, Time.new(2022, 1, 1), 'Yet Another Title', true)
    expect(music_album.can_be_archived?).to be(false)
  end
end
