require 'bcrypt'

class String
	def to_password_hash
		BCrypt::Password.create(self)
	end
	def to_password_hash!
		replace to_password_hash
	end
end

class User < ActiveRecord::Base
	has_ancestry

	belongs_to :recruit_code

	has_many :transactions_from,
		foreign_key: 'from_id',
		class_name: 'Transaction'

	has_and_belongs_to_many :transactions_to,
		class_name: 'Transaction',
		join_table: 'users_transactions'

	validates :name, presence: true,
		length: { minimum: 3 },
		uniqueness: { case_sensitive: false },
		format: { with: /\A[A-Za-z0-9]+\z/, message: "must be alphanumeric" }
	validates :password, presence: true

	before_save :hash_password_hook

	def earned
		transactions_to
			.map do |t| t.amount self end
			.reduce(0, :+) - transactions_from.sum(:amount)
	end

	def earned_from(user)
		Transaction
			.joins(:to, :from)
			.where(
				'users_transactions.user_id = ? OR transactions.from_id = ?',
				user.id,
				user.id
			)
			.distinct
			.map do |t| t.amount self end
			.reduce(0, :+)
	end

	def transactions
		transactions_to
			.where.not(from_id: nil)
			.order(created_at: :desc)
	end

	def fee_payed
		Payment.find_by(user_id: id)&.confirmed
	end

	def self.authenticate(name, password)
		@user = User.where("lower(name) = ?", name.downcase).first

		return if @user.nil?

		@user if BCrypt::Password.new(@user.password) == password
	end

	def to_s
		name
	end

	protected
		def hash_password_hook
			self.password.to_password_hash!
		end
end
