class Transaction < ActiveRecord::Base
	belongs_to :from, class_name: 'User', foreign_key: 'from_id'
	belongs_to :to, class_name: 'User', foreign_key: 'to_id'

	validates_associated :to
	validates_associated :from
	validates :amount, numericality: { greater_than: 0 }

	enum reason: [:user_joined]
end
