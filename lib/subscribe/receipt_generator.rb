# frozen_string_literal: true

require_relative "../receipt.rb"
require_relative "../receipt_item.rb"

module Subscribe
  class ReceiptGenerator
    def initialize
      @receipt = Receipt.new
    end

    def run
      puts "Welcome to the SUBSCRIBE receipt generator..."
      puts "Please enter the items you would like to generate a receipt for:"

      loop do
        input = $stdin.gets.chomp
        break if input.empty?

        begin
          receipt_item_data = validate_input(input)

          item = handle_receipt_item(receipt_item_data)
        rescue ArgumentError => e
          puts "Error: #{e.message}"
          puts "Please correct the input and try again."
        end
      end

      print_receipt
    end

    def print_receipt
      puts "=" * 100
      @receipt.items.each do |item|
        item_sting = "#{item.quantity}"
        item_sting += " imported" unless item.import_tax.zero?
        item_sting += " #{item.name}"
        item_sting += ": #{item.total}"
        puts item_sting
      end
      puts "Sales Taxes: #{format("%.2f", @receipt.tax)}"
      puts "Total: #{format("%.2f", @receipt.total)}"
    end

    def handle_receipt_item(item_data)
      item = ReceiptItem.new(
        quantity: item_data[:quantity].to_i,
        name: item_data[:name].strip,
        import_tax: !!item_data[:imported],
        price: item_data[:price].to_f
      )

      @receipt.add_item(item)
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
