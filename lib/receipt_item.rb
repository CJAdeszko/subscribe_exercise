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
    @total += sales_tax
    @total += import_tax
    @total.round(2)
  end

  def sales_tax
    return 0 unless @taxable

    (((@price * @quantity * 0.10) / 0.05).ceil * 0.05)
  end

  def import_tax
    return 0 unless @import_tax

   (@price.ceil * 0.05 * @quantity)
  end

  def taxable?
    return false if TAX_EXEMPT_ITEMS.any? { |exempt_item| @name.downcase.include?(exempt_item.downcase) }

    true
  end
end
