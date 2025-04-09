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
        price: item_data[:price].to_f
      )

      receipt.add_item(item)
    end

    def validate_input(input)
      match_data = input.match(/^(?<quantity>\d+)\s(?<name>.+?)\sat\s(?<price>\d+\.\d{2})$/)
      unless match_data && match_data.names.all? { |key| match_data[key] }
        raise ArgumentError, "Invalid input format. Expected: 'QUANTITY NAME at PRICE' (e.g., '2 book at 12.49')"
      end

      match_data
    end
  end
end
