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

	validates :name, presence: true,
		length: { minimum: 3 },
		uniqueness: { case_sensitive: false },
		format: { with: /\A[A-Za-z0-9]+\z/, message: "must be alphanumeric" }
	validates :password, presence: true

	before_save :hash_password_hook

	def earned
		#TODO implement this
		12
	end

	def transactions
		subtree
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
