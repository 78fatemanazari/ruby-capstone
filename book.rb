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
end
