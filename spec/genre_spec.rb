# genre_spec.rb

require_relative '../genre'
require_relative '../music_album'

RSpec.describe Genre do
  let(:genre) { Genre.new(1, 'Pop') }
  let(:music_album) { MusicAlbum.new(1, Time.new(2020, 1, 1), true) }

  it "adds an item to the genre's collection" do
    expect(genre.items).to be_empty

    genre.add_item(music_album)

    expect(genre.items.length).to eq(1)
    expect(genre.items).to include(music_album)
    expect(music_album.genres).to include(genre)
  end
end
