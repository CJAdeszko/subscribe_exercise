require 'receipt'

RSpec.describe Receipt do
  describe '#initialize' do
    it 'initializes with an empty items array' do
      receipt = Receipt.new
      expect(receipt.items).to eq([])
    end
  end

  describe '#add_item' do
    it 'adds an item to the items array' do
      receipt = Receipt.new
      item = double('Item')
      receipt.add_item(item)
      expect(receipt.items).to include(item)
    end
  end

  describe '#total' do
    it 'calculates the total price of all items' do
      receipt = Receipt.new
      item1 = double('Item', total: 10.0)
      item2 = double('Item', total: 20.0)
      receipt.add_item(item1)
      receipt.add_item(item2)
      expect(receipt.total).to eq(30.0)
    end
  end

  describe '#tax' do
    it 'calculates the total sales tax of all items' do
      receipt = Receipt.new
      item1 = double('Item', sales_tax: 1.0, import_tax: 0.5)
      item2 = double('Item', sales_tax: 2.0, import_tax: 1.0)
      receipt.add_item(item1)
      receipt.add_item(item2)
      expect(receipt.tax).to eq(4.5)
    end
  end

end
