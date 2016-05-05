module TransactionHelper
	CURRENCY_SYMBOL = ['&#x25B2;', '&#x25B3;', '&#x25B4;', '&#x25B5;'][0]

	def as_currency(value)
		"#{CURRENCY_SYMBOL}#{'%.2f' % value}".html_safe
	end
end
