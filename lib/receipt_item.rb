class ReceiptItem
  attr_accessor :name, :price, :quantity, :taxable, :import_tax

  TAX_EXEMPT_ITEMS = %W[book chocolate headache\ pills].freeze

  def initialize(name:, price:, quantity:, taxable: true, import_tax: false)
    @name = name
    @price = price
    @quantity = quantity
    @taxable = taxable
    @import_tax = import_tax
  end
end
