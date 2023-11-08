# item.rb

class Item
  attr_reader :id, :publish_date
  attr_accessor :archived, :genres, :authors, :labels, :sources

  def initialize(id, publish_date)
    @id = id
    @publish_date = publish_date
    @archived = false
    @genres = []
    @authors = []
    @labels = []
    @sources = []
  end

  def can_be_archived?
    # Check if the published_date is older than 10 years
    (Time.now.year - publish_date.year) > 10
  end

  def move_to_archive
    return unless can_be_archived?

    @archived = true
  end

  # Custom setter methods for 1-to-many relationships
  def add_genre(genre)
    @genres << genre
  end

  def add_author(author)
    @authors << author
  end

  def label=(label)
    @labels << label
  end

  def add_source(source)
    @sources << source
  end
end
