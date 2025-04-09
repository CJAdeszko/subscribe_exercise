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

  def sales_tax
    @items.reduce(0) do |sum, item|
      sum + item.calculate_sales_tax
    end
  end
end
