# label.rb

class Label
  attr_reader :name
  attr_accessor :items

  def initialize(name)
    @name = name
    @items = []
  end

  def add_item(item)
    items << item
    item.label = self
  end
end
