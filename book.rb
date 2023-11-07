class Book < Item
  attr_reader :title, :author, :cover_state

  def initialize(id, publish_date, title, author, cover_state)
    super(id, publish_date)
    @title = title
    @author = author
    @cover_state = cover_state
  end

  def can_be_archived?
    super || cover_state == 'bad'
  end
end
