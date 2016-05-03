class Transaction < ActiveRecord::Base
	has_ancestry

	belongs_to :from, class_name: 'User', foreign_key: 'from_id'
	belongs_to :to, class_name: 'User', foreign_key: 'to_id'

	validates_associated :to
	validates_associated :from
	validates :amount, numericality: { greater_than: 0 }

	enum reason: [:user_joined]

	def to_s
		"#{if from.nil? then 'nil' else from.name end}" \
		" -> #{if to.nil? then 'nil' else to.name end}" \
		" #{'%.2f' % (amount / 100)}"
	end
end
