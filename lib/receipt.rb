class Receipt
  attr_accessor :items

  def initialize
    @items = []
  end

  def add_item(item)
    puts "CURRENT ITEMS: #{@items.inspect}"
    puts "Adding item: #{item.inspect}"
    @items << item
    puts "ITEMS AFTER ADDING: #{@items.inspect}"
  end
end
