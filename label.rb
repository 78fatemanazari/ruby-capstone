class Label
  attr_reader :id, :title, :color
  attr_accessor :items

  def initialize(id, title, color)
    @id = id
    @title = title
    @color = color
    @items = []
  end

  def add_item(item)
    items << item
    item.label = self
  end

  def to_json(*_args)
    {
      id: id,
      title: title,
      color: color,
      items: items.map(&:id)
    }.to_json
  end

  def self.from_json(json)
    data = JSON.parse(json)
    label = new(data['id'], data['title'], data['color'])
    data['items'].each do |item_id|
      # Find the associated item from your collection and add it to the label
      item = items.find { |i| i.id == item_id }
      label.add_item(item) if item
    end
    label
  end
end
