class Transaction < ActiveRecord::Base
	belongs_to :from,
		class_name: 'User',
		foreign_key: 'from_id'

	has_and_belongs_to_many :to,
		class_name: 'User',
		join_table: 'users_transactions'

	validates :amount, numericality: { greater_than: 0 }

	enum reason: [:user_joined]

	def up_to(user)
		to.order(created_at: :desc)[0..-user.path.size]
	end

	def amount(user = nil)
		@amount = read_attribute(:amount)

		if to.size > 1 && !user.nil?
			@amount /= 2**(to.order(created_at: :desc).find_index(user) + 1)
		end

		@amount
	end

	def to_s
		"#{if from.nil? then 'nil' else from.name end}" \
		" -> #{if to.nil? then 'nil' else to.all.join(', ') end}" \
		" #{amount}"
	end
end
