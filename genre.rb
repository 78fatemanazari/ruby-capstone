# genre.rb

class Genre
  attr_accessor :id, :name, :items

  def initialize(id, name)
    @id = id
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item
    item.add_genre(self) # Call the custom setter from the Item class
  end

  def self.list_all_genres(genres)
    puts 'List of all genres:'
    genres.each do |genre|
      puts genre.name
    end
  end
end
