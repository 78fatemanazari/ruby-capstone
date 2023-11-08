require_relative '../book'
require_relative '../item'

RSpec.describe Book do
  describe '#can_be_archived?' do
    context 'when the book has a bad cover state' do
      it 'returns true' do
        book = Book.new(id: 1, publish_date: Time.now, title: 'Test Book', author: 'Test Author', cover_state: 'bad',
                        publisher: 'Test Publisher')

        expect(book.can_be_archived?).to be true
      end
    end

    context 'when the book is older than 10 years' do
      it 'returns true' do
        ten_years_ago = Time.now - (365 * 10 * 24 * 60 * 60) # 10 years in seconds
        book = Book.new(id: 1, publish_date: ten_years_ago, title: 'Test Book', author: 'Test Author',
                        cover_state: 'good', publisher: 'Test Publisher')

        expect(book.can_be_archived?).to be true
      end
    end

    context 'when the book is not older than 10 years and has a good cover' do
      it 'returns false' do
        nine_years_ago = Time.now - (365 * 9 * 24 * 60 * 60) # 9 years in seconds
        book = Book.new(id: 1, publish_date: nine_years_ago, title: 'Test Book', author: 'Test Author',
                        cover_state: 'good', publisher: 'Test Publisher')

        expect(book.can_be_archived?).to be false
      end
    end
  end
end
