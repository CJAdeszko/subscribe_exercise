# frozen_string_literal: true

require_relative "../receipt.rb"
require_relative "../receipt_item.rb"

module Subscribe
  class ReceiptGenerator
    def run
      puts "Welcome to the SUBSCRIBE receipt generator..."
      puts "Please enter the ledger item you would like to generate a receipt for:"

      loop do
        print "> "
        input = $stdin.gets.chomp
        break if input.empty?

        begin
          receipt_item_data = validate_input(input)

          receipt = Receipt.new

          handle_receipt_item(receipt_item_data, receipt)
        rescue ArgumentError => e
          puts "Error: #{e.message}"
          puts "Please correct the input and try again."
        end
      end
    end

    def handle_receipt_item(item_data, receipt)
      item = ReceiptItem.new(
        quantity: item_data[:quantity].to_i,
        name: item_data[:name].strip,
        import_tax: !!item_data[:imported],
        price: item_data[:price].to_f
      )

      receipt.add_item(item)
    end

    def validate_input(input)
      match_data = input.match(/^(?<quantity>\d+)\s(?<imported>imported\s)?(?<name>.+?)\s+at\s+(?<price>\d+\.\d{2})$/i)
      unless match_data && %i[quantity name price].all? { |k| match_data[k] }
        raise ArgumentError, "Invalid format. Expected: 'QUANTITY [imported] NAME at PRICE'"
      end

      match_data
    end
  end
end
