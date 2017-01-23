module TransactionHelper
	CURRENCY_SYMBOL = ['&#x25B2;', '&#x25B3;', '&#x25B4;', '&#x25B5;'][0]

	def as_currency(value, symbol=false)
		"#{CURRENCY_SYMBOL if symbol}#{'%.4f' % value}".html_safe
	end
end
