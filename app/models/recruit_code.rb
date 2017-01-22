class RecruitCode < ActiveRecord::Base
	EXPIRE_AFTER = 24 * 60 * 60 - 1

	belongs_to :owner

	validates :code, presence: true,
		uniqueness: { case_sensitive: true }
	validates :owner_id, presence: true
	validates :claimed, :inclusion => {:in => [true, false]}

	def availability
		if !id
			'no recruit code'
		elsif claimed
			'recruit code claimed'
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
			claimed: false
		)
	end

	def self.owned_by(user)
		where(owner: user.id, claimed: false)
	end
end
