# book.rb

class Book < Item
  attr_reader :title, :author, :cover_state, :publisher

  def initialize(params)
    super(params[:id], params[:publish_date])
    @title = params[:title]
    @author = params[:author]
    @cover_state = params[:cover_state]
    @publisher = params[:publisher]
  end

  def can_be_archived?
    super || cover_state == 'bad'
  end
end
