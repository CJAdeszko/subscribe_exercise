class Receipt
  attr_accessor :items

  def initialize
    @items = []
  end

  def add_item(item)
    @items << item
  end

  def total
    @items.reduce(0) do |sum, item|
      sum + item.total
    end
  end

  def tax
    @items.reduce(0) do |sum, item|
      sum + item.sales_tax + item.import_tax
    end
  end
end
