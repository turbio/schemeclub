require 'rails_helper'
require 'time'

RSpec.describe RecruitCode, type: :model do
	describe 'create' do
		it 'should create a recruit code using generator' do
			owner = User.create!(name: 'username', password: 'password')
			code = RecruitCode.generate_new_code owner
		end

		it 'should not create a recruit code without an owner' do
			expect do
				code = RecruitCode.create!()
			end.to raise_error(
				ActiveRecord::RecordInvalid,
				/Code can't be blank, Owner can't be blank, Claimed is not.../)
		end

		it 'should generate recruit codes with random code' do
			owner = User.create!(name: 'owner', password: 'password')

			first = RecruitCode.generate_new_code owner
			second = RecruitCode.generate_new_code owner
			third = RecruitCode.generate_new_code owner

			expect(first.code).not_to eq(second.code)
			expect(second.code).not_to eq(third.code)
		end
	end

	it 'should get all codes owned by a user' do
		owner = User.create!(name: 'owner', password: 'password')

		first = RecruitCode.generate_new_code owner
		second = RecruitCode.generate_new_code owner
		third = RecruitCode.generate_new_code owner

		expect(RecruitCode.owned_by(owner).length).to eq(3)
		expect(RecruitCode.owned_by(owner).first).to eq(first)
	end

	describe 'availability' do
		it 'should get code time remaining' do
			owner = User.create!(name: 'owner', password: 'password')
			code = RecruitCode.generate_new_code owner

			expect(code.remaining_seconds).to be_a(Float)
			expect(code.remaining_seconds).to be > 0
		end

		it 'should not be available after claimed' do
			owner = User.create!(name: 'owner', password: 'password')
			code = RecruitCode.generate_new_code owner

			expect(code.expired?).to eq(false)
			expect(code.available?).to eq(true)
			expect(code.availability).to eq(nil)

			code.claimed = true
			code.save

			expect(code.available?).to eq(false)
			expect(code.availability).to eq('recruit code claimed')
		end

		it 'should not be available after expired' do
			owner = User.create!(name: 'owner', password: 'password')
			code = RecruitCode.generate_new_code owner

			expect(code.expired?).to eq(false)
			expect(code.available?).to eq(true)
			expect(code.availability).to eq(nil)

			#a while ago... Probably
			code.created_at = Time.parse '1900-1-1'
			code.save

			expect(code.available?).to eq(false)
			expect(code.availability).to eq('recruit code expired')
		end
	end
end
