require_relative '../book'
require 'rspec'

RSpec.describe Book do
  let(:book_params) do
    {
      id: 1,
      publish_date: Time.new(2022, 1, 1),
      title: 'Test Book',
      author: 'Test Author',
      cover_state: 'good',
      publisher: 'Test Publisher'
    }
  end

  subject { Book.new(book_params) }

  it 'has title, author, cover_state, and publisher attributes' do
    expect(subject.title).to eq('Test Book')
    expect(subject.author).to eq('Test Author')
    expect(subject.cover_state).to eq('good')
    expect(subject.publisher).to eq('Test Publisher')
  end

  it 'can be archived if cover_state is bad' do
    subject.cover_state = 'bad'
    expect(subject.can_be_archived?).to be true
  end

  it 'can be archived if super class allows it' do
    book_params = {
      id: 1,
      publish_date: Time.new(2012, 1, 1), # An example from more than 10 years ago
      title: 'Test Book',
      author: 'Test Author',
      cover_state: 'good',
      publisher: 'Test Publisher'
    }
    book = Book.new(book_params)

    expect(book.can_be_archived?).to be true
  end
end
