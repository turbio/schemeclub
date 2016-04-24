class RecruitCode < ActiveRecord::Base
	belongs_to :owner

	validates :code, presence: true,
		uniqueness: { case_sensitive: false },
		length: { is: 5 }
	validates :owner, presence: true
	validates :claimed, presence: true

	def self.code_exists?(code)
		!RecruitCode.find_by_code(code).nil?
	end

	def self.code_available?(code)
		@code = RecruitCode.find_by_code(code)
		!@code.claimed unless @code.nil?
	end

	def self.new_code(user, length=5)
		@allowed_chars = ('a'..'z').to_a + ('0'..'9').to_a

		@generated_code = length.times.map do
			@allowed_chars.sample
		end.join

		RecruitCode.create(code: @generated_code, user: user)
	end
end
