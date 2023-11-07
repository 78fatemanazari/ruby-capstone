require_relative '../book'

describe Book do
  let(:book_params) do
    {
      id: 1,
      publish_date: Time.new(2020, 1, 1),
      title: 'Sample Book',
      author: 'John Doe',
      cover_state: 'good',
      publisher: 'Example Publisher'
    }
  end
  let(:book) { Book.new(book_params) }

  it 'should return true if cover_state is "bad"' do
    book_params[:cover_state] = 'bad'
    book = Book.new(book_params)
    expect(book.can_be_archived?).to be(true)
  end

  it 'should return false if cover_state is not "bad" and parent method returns false' do
    book_params[:cover_state] = 'good'
    book = Book.new(book_params)
    expect(book.can_be_archived?).to be(false)
  end
end
