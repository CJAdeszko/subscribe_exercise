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

        receipt = Receipt.new

        handle_receipt_item(input, receipt)
      end
    end

    def handle_receipt_item(input, receipt)
      match_data = input.match(/^(?<quantity>\d+)\s(?<name>.+?)\sat\s(?<price>\d+\.\d{2})$/)
      if match_data
        item = ReceiptItem.new(
          quantity: match_data[:quantity].to_i,
          name: match_data[:name].strip,
          price: match_data[:price].to_f
        )

        receipt.add_item(item)
      end
    end
  end
end
