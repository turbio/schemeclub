class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :name, null: false
			t.string :password, null: false
			t.string :ancestry
			t.references(:recruit_code, index: true, null: true);

			t.timestamps null: false
		end
	end
end
