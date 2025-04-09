class ReceiptItem
  attr_accessor :name, :price, :quantity, :taxable, :import_tax, :total

  TAX_EXEMPT_ITEMS = %W[book chocolate headache\ pills].freeze

  def initialize(name:, price:, quantity:, import_tax: false)
    @name = name
    @price = price
    @quantity = quantity
    @taxable = taxable?
    @import_tax = import_tax
  end

  def total
    @total = @price * @quantity
    @total += calculate_sales_tax if @taxable
    @total += calculate_import_tax if @import_tax
    @total
  end

  def calculate_sales_tax
    @price * 0.10
  end

  def calculate_import_tax
    @price * 0.05
  end

  def taxable?
    return false if TAX_EXEMPT_ITEMS.any? { |exempt_item| @name.downcase.include?(exempt_item.downcase) }
    true
  end
end
