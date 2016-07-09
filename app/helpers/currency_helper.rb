module CurrencyHelper
  def number_to_indian_currency(number)
    'Rs. ' + number_to_currency(number).gsub('$', '')
  end
end
