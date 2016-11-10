class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :name, null: false
			t.string :password, null: false
			t.string :ancestry
			t.boolean :state, null: false, default: 0

			t.timestamps null: false
		end
	end
end
