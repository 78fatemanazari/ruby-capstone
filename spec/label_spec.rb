require_relative '../label'

describe Label do
  let(:label) { Label.new(1, 'Sample Label', 'Blue') }
  let(:item) { Item.new(1, Time.new(2020, 1, 1)) }

  it 'should add an item to the collection of items' do
    label.add_item(item)
    expect(label.items).to include(item)
  end

  it 'should set self as the label of the item' do
    label.add_item(item)
    expect(item.label).to eq(label)
  end
end
