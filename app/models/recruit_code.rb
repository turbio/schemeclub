class RecruitCode < ActiveRecord::Base
	EXPIRE_AFTER = 24 * 60 * 60 - 1

	belongs_to :owner

	validates :code, presence: true,
		uniqueness: { case_sensitive: true }
	validates :owner_id, presence: true
	validates :claimed, :inclusion => {:in => [true, false]}

	def remaining_time
		@age = Time.zone.now - created_at
		@remaining = EXPIRE_AFTER - @age

		if @remaining > 0
			Time.at(@remaining).utc
		else
			false
		end
	end

	def available?
		(not claimed) and remaining_time
	end

	def self.generate_new_code(user, length=4)
		@allowed_chars = ('a'..'z').to_a + ('0'..'9').to_a

		@generated_code = length.times.map do
			@allowed_chars.sample
		end.join

		RecruitCode.create(code: @generated_code, owner_id: user.id, claimed: false)
	end
end
