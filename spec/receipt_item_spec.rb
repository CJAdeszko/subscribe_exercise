require 'receipt_item'

RSpec.describe ReceiptItem do
  describe '#initialize' do
    it 'initializes with the correct attributes' do
      item = ReceiptItem.new(name: 'book', price: 12.49, quantity: 1, import_duty: false)
      expect(item.name).to eq('book')
      expect(item.price).to eq(12.49)
      expect(item.quantity).to eq(1)
      expect(item.taxable).to be(false)
      expect(item.import_duty).to be(false)
    end

    it 'raises an error if name is missing' do
      expect { ReceiptItem.new(price: 12.49, quantity: 1) }.to raise_error(ArgumentError)
    end

    it 'raises an error if price is missing' do
      expect { ReceiptItem.new(name: 'book', quantity: 1) }.to raise_error(ArgumentError)
    end

    it 'raises an error if quantity is missing' do
      expect { ReceiptItem.new(name: 'book', price: 12.49) }.to raise_error(ArgumentError)
    end
  end

  describe '#total' do
    context 'when the item is not taxable' do
      it 'calculates the total price without including tax' do
        item = ReceiptItem.new(name: 'book', price: 12.49, quantity: 1, import_duty: false)
        expect(item.total).to eq(12.49)
      end

      context 'when the item is subject to import duty' do
        it 'calculates the total price including import tax' do
          item = ReceiptItem.new(name: 'imported chocolate bar', price: 10.00, quantity: 1, import_duty: true)
          expect(item.total).to eq(10.50)
        end
      end
    end

    context 'when the item is taxable' do
      it 'calculates the total price with sales tax' do
        item = ReceiptItem.new(name: 'music CD', price: 14.99, quantity: 1, import_duty: false)
        expect(item.total).to eq(16.49)
      end

      context 'when the item is subject to import duty' do
        it 'calculates the total price with both sales import tax' do
          item = ReceiptItem.new(name: 'imported chocolate bar', price: 10.00, quantity: 1, import_duty: true)
          expect(item.total).to eq(10.50)
        end
      end
    end
  end

  describe '#sales_tax' do
    it 'calculates the sales tax for taxable items' do
      item = ReceiptItem.new(name: 'music CD', price: 14.99, quantity: 1, import_duty: false)
      expect(item.sales_tax).to eq(1.50)
    end

    it 'returns 0 for non-taxable items' do
      item = ReceiptItem.new(name: 'book', price: 12.49, quantity: 1, import_duty: false)
      expect(item.sales_tax).to eq(0)
    end
  end

  describe '#import_tax' do
    it 'calculates the import tax for imported items' do
      item = ReceiptItem.new(name: 'imported chocolate bar', price: 10.00, quantity: 1, import_duty: true)
      expect(item.import_tax).to eq(0.50)
    end

    it 'returns 0 for non-imported items' do
      item = ReceiptItem.new(name: 'book', price: 12.49, quantity: 1, import_duty: false)
      expect(item.import_tax).to eq(0)
    end
  end

  describe '#taxable?' do
    it 'returns true for taxable items' do
      item = ReceiptItem.new(name: 'music CD', price: 14.99, quantity: 1, import_duty: false)
      expect(item.taxable?).to be(true)
    end

    it 'returns false for exempt items' do
      item = ReceiptItem.new(name: 'chocolate bar', price: 0.85, quantity: 1, import_duty: false)
      expect(item.taxable?).to be(false)
    end
  end
end
