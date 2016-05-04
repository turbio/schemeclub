class Transaction < ActiveRecord::Base
	has_ancestry

	belongs_to :from, class_name: 'User', foreign_key: 'from_id'
	belongs_to :to, class_name: 'User', foreign_key: 'to_id'

	validates_associated :to
	validates_associated :from
	validates :amount, numericality: { greater_than: 0 }

	enum reason: [:user_joined]

	after_validation :distribute_wealth

	def to_s
		"#{if from.nil? then 'nil' else from.name end}" \
		" -> #{if to.nil? then 'nil' else to.name end}" \
		" #{'%.2f' % (amount / 100)}"
	end

	protected
		def distribute_wealth(transaction=self)
			@to, @from =
				if transaction.to.nil?
					[transaction.from.parent || return, transaction.from]
				else
					[transaction.to.parent || return, transaction.to]
				end

			@amount =
				if @to.parent.nil?
					transaction.amount
				else
					transaction.amount / 2
				end

			@subtrans = Transaction.create(
				parent_id: transaction.id,
				to_id: @to.id,
				from_id: @from.id,
				amount: @amount,
				reason: transaction.reason)

			distribute_wealth @subtrans
		end
end
