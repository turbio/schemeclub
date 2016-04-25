class RecruitCode < ActiveRecord::Base
	belongs_to :owner

	validates :code, presence: true,
		uniqueness: { case_sensitive: true }
	validates :owner_id, presence: true
	validates :claimed, :inclusion => {:in => [true, false]}

	def self.code_exists?(code)
		!RecruitCode.find_by_code(code).nil?
	end

	def self.code_available?(code)
		@code = RecruitCode.find_by_code(code)
		!@code.claimed unless @code.nil?
	end

	def self.generate_new_code(user, length=4)
		@allowed_chars = ('a'..'z').to_a + ('0'..'9').to_a

		@generated_code = length.times.map do
			@allowed_chars.sample
		end.join

		RecruitCode.create(code: @generated_code, owner_id: user.id, claimed: false)
	end
end
