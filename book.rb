require_relative 'item'

class Book < Item
  attr_reader :title, :author, :publisher
  attr_accessor :cover_state, :label

  def initialize(params)
    super(params[:id], params[:publish_date])
    @title = params[:title]
    @author = params[:author]
    @cover_state = params[:cover_state]
    @publisher = params[:publisher]
    @label = nil
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end

  def assign_label(label)
    @label = label
  end

  def to_json(*_args)
    {
      id: id,
      publish_date: publish_date,
      title: title,
      author: author,
      cover_state: cover_state,
      publisher: publisher
    }.to_json
  end

  def self.from_json(json)
    data = JSON.parse(json)
    new(data)
  end
end
