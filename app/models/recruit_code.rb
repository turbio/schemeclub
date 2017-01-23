class RecruitCode < ActiveRecord::Base
	has_many :users
	belongs_to :owner

	validates :code, presence: true,
		uniqueness: { case_sensitive: true }
	validates :owner_id, presence: true

	def availability
		if !id
			'no recruit code'
		end
	end

	def self.generate_new_code(user, length=4)
		numbers = ('0'..'9').to_a

		allowed_chars = ('a'..'z').to_a + numbers
		first_char = numbers

		generated_code =
			first_char.sample +
			(length - 1).times.map do |i| allowed_chars.sample end.join

		RecruitCode.create(
			code: generated_code,
			owner_id: user.id,
		)
	end

	def self.owned_by(user)
		where(owner: user.id)
	end
end
