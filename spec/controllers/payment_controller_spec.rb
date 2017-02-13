require 'rails_helper'

RSpec.describe PaymentController, type: :controller do
	#it 'should show transactions to a user' do
		#dan = User.create!(name: 'dan', password: 'insecurepassword')
		#ellen = User.create!(
			#name: 'ellen',
			#password: 'correcthorse',
			#parent_id: dan.id)

		#expect(dan.transactions.length).to eq 1
		#expect(ellen.transactions.length).to eq 0

		#expect(dan.transactions.first.from_id).to eq ellen.id

		#erin = User.create!(
			#name: 'erin',
			#password: 'whoami',
			#parent_id: dan.id)

		#expect(dan.transactions.length).to eq 2
		#expect(ellen.transactions.length).to eq 0
		#expect(erin.transactions.length).to eq 0
	#end

	#it 'should show amount earned from user' do
		#dog = User.create!(name: 'dog', password: 'password123')

		#fred = User.create!(
			#name: 'fred',
			#password: 'password123',
			#parent_id: dog.id)
		#gary = User.create!(
			#name: 'gary',
			#password: 'incorrecthorse',
			#parent_id: fred.id)

		#expect(fred.earned_from gary).to eq 5

		#harry = User.create!(
			#name: 'harry',
			#password: 'imawizard',
			#parent_id: gary.id)

		#expect(fred.earned_from gary).to eq 7.5
		#expect(fred.earned_from harry).to eq 2.5
	#end

	#it 'should show total amount earned' do
		#top = User.create!(name: 'top', password: 'password123')

		#ian = User.create!(
			#name: 'ian',
			#password: 'password123',
			#parent_id: top.id)

		#jack = User.create!(
			#name: 'jack',
			#password: 'incorrecthorse',
			#parent_id: ian.id)

		#kathrin = User.create!(
			#name: 'kathrin',
			#password: 'imawizard',
			#parent_id: jack.id)

		#expect(ian.earned).to eq 7.5
		#expect(jack.earned).to eq 5
		#expect(kathrin.earned).to eq 0
	#end
end
