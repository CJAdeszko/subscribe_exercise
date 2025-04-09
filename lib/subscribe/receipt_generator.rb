module Subscribe
  class ReceiptGenerator
    def run
      puts "Welcome to the SUBSCRIBE receipt generator..."
      puts "Please enter the ledger item you would like to generate a receipt for:"

      loop do
        print "> "
        input = $stdin.gets.chomp
        break if input.empty?

        handle_ledger_item(input)

      end
    end

    def handle_ledger_item(input)
      puts "Receipt for item: #{input}"
    end
  end
end
