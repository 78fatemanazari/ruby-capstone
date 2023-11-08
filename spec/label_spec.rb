require_relative '../label'

describe Label do
  let(:label) { Label.new(1, 'Test Label', 'red') }

  it 'has id, title, and color attributes' do
    expect(label.id).to eq(1)
    expect(label.title).to eq('Test Label')
    expect(label.color).to eq('red')
  end

  it 'can add items' do
    book = Book.new({ id: 2, publish_date: Time.new(2022, 1, 1),
                      title: 'Test Book',
                      author: 'Test Author',
                      cover_state: 'good',
                      publisher: 'Test Publisher' })
    label.add_item(book)
    expect(label.items).to include(book)
    expect(book.label).to eq(label)
  end
end
