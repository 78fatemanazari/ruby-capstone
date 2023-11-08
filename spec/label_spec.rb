require_relative '../label'
require_relative '../item'

RSpec.describe Label do
  describe '#add_item' do
    it 'adds an item to the label' do
      label = Label.new(1, 'Test Label', 'Red')
      item = Item.new(1, Time.now)
      label.add_item(item)

      expect(label.items).to include(item)
      expect(item.label).to eq(label)
    end
  end
end
