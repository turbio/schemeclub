class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :amount, null: false
      t.integer :direction, null: false
      t.string :address, null: false
      t.boolean :confirmed, null: false, default: false

      t.timestamps null: false
    end
  end
end
