require 'subscribe/receipt_generator'

RSpec.describe Subscribe::ReceiptGenerator do
  let(:receipt_generator) { described_class.new }

  describe '#run' do
    it 'prompts the user for input and processes it' do
      allow($stdin).to receive(:gets).and_return("1 book at 12.49", "", "2 imported bottles of perfume at 27.99")
      receipt_generator = described_class.new
      expect(receipt_generator).to receive(:print_receipt)
      receipt_generator.run
    end

    it 'handles invalid input gracefully' do
      allow($stdin).to receive(:gets).and_return("invalid input", "")
      receipt_generator = described_class.new
      expect { receipt_generator.run }.to output(/Error: Invalid format/).to_stdout
    end
  end

  describe '#print_receipt' do
    let(:receipt) { Receipt.new }

    before do
      receipt.add_item(receipt_item)
    end

    context 'when the receipt contains taxable items' do
      let(:receipt_item) { ReceiptItem.new(name: 'CD', price: 14.99, quantity: 1, import_duty: false) }

      it 'prints the receipt details correctly' do
        allow_any_instance_of(described_class).to receive(:receipt).and_return(receipt)

        expect { receipt_generator.print_receipt }.to output(/1 CD: 16.49/).to_stdout
        expect { receipt_generator.print_receipt }.to output(/Sales Taxes: 1.50/).to_stdout
        expect { receipt_generator.print_receipt }.to output(/Total: 16.49/).to_stdout
      end
    end

    context 'when the receipt contains only non-taxable items' do
    let(:receipt_item) { ReceiptItem.new(quantity: 1, name: 'book', price: 12.49, import_duty: false) }

      it 'prints the receipt details correctly' do
        allow_any_instance_of(described_class).to receive(:receipt).and_return(receipt)

        receipt_generator = described_class.new
        expect { receipt_generator.print_receipt }.to output(/1 book: 12.49/).to_stdout
        expect { receipt_generator.print_receipt }.to output(/Sales Taxes: 0.00/).to_stdout
        expect { receipt_generator.print_receipt }.to output(/Total: 12.49/).to_stdout
      end
    end
  end

  describe '#handle_receipt_item' do
    subject(:handle_receipt_item) { receipt_generator.handle_receipt_item(item_data) }
    let(:receipt) { Receipt.new }

    before do
      allow(receipt_generator).to receive(:receipt).and_return(receipt)
      allow(ReceiptItem).to receive(:new).and_return(receipt_item)
    end

    context 'when the item is not imported' do
      let(:item_data) { { quantity: 1, name: 'book', imported: nil, price: '12.49'} }
      let(:receipt_item) { ReceiptItem.new(quantity: 1, name: 'book', import_duty: false, price: 12.49) }

      it 'creates a ReceiptItem and adds it to the receipt' do
        expect(ReceiptItem).to receive(:new).with(
          quantity: 1,
          name: 'book',
          import_duty: false,
          price: 12.49
        )
        subject
      end

      it 'adds the item to the receipt' do
        expect(receipt).to receive(:add_item).with(receipt_item)
        subject
      end
    end

    context 'when the item is imported' do
      let(:item_data) { { quantity: 2, name: 'imported perfume', imported: 'imported', price: '27.99' } }
      let(:receipt_item) { ReceiptItem.new(quantity: 2, name: 'imported perfume', import_duty: true, price: 27.99 ) }

      it 'creates a ReceiptItem with import duty set to true' do
        expect(ReceiptItem).to receive(:new).with(
          quantity: 2,
          name: 'imported perfume',
          import_duty: true,
          price: 27.99
        )
        subject
      end

      it 'adds the item to the receipt' do
        expect(receipt).to receive(:add_item).with(receipt_item)
        subject
      end
    end
  end

  describe '#validate_input' do
    it 'validates the input format correctly' do
      receipt_generator = described_class.new
      valid_input = "1 imported bottle of perfume at 27.99"
      expect(receipt_generator.validate_input(valid_input)).to be_a(MatchData)
    end

    it 'returns match data with correct keys' do
      receipt_generator = described_class.new
      valid_input = "1 imported bottle of perfume at 27.99"
      match_data = receipt_generator.validate_input(valid_input)

      expect(match_data[:quantity]).to eq("1")
      expect(match_data[:imported]).to eq("imported ")
      expect(match_data[:name]).to eq("bottle of perfume")
      expect(match_data[:price]).to eq("27.99")
    end

    it 'raises an error for invalid input format' do
      receipt_generator = described_class.new
      invalid_input = "invalid input"
      expect { receipt_generator.validate_input(invalid_input) }.to raise_error(ArgumentError, /Invalid format/)
    end

    it 'raises an error for missing required fields' do
      receipt_generator = described_class.new
      incomplete_input = "1 imported bottle of perfume at"
      expect { receipt_generator.validate_input(incomplete_input) }.to raise_error(ArgumentError, /Invalid format/)
    end
  end
end
