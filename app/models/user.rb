class String
	def to_password_hash
		self + 'wew security'
	end
	def to_password_hash!
		replace to_password_hash
	end
end

class User < ActiveRecord::Base
	has_ancestry

	has_many :transactions_from, foreign_key: 'from_id', class_name: 'Transaction'
	has_many :transactions_to, foreign_key: 'to_id', class_name: 'Transaction'

	validates :name, presence: true,
		length: { minimum: 3 },
		uniqueness: { case_sensitive: false },
		format: { with: /\A[A-Za-z0-9]+\z/, message: "must be alphanumeric" }
	validates :password, presence: true

	before_save :hash_password_hook

	def earned
		self.transactions_to.sum(:amount) - self.transactions_from.sum(:amount)
	end

	def transactions
		self.transactions_to + self.transactions_from
	end

	def self.authenticate(name, password)
		@hashed_password = password.to_password_hash
		User.where(
			"lower(name) = ? AND password = ?",
			name.downcase,
			@hashed_password).first
	end

	protected
		def hash_password_hook
			self.password.to_password_hash!
		end
end
