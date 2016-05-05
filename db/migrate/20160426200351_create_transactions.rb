class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :from, index: true, foreign_key: true, null: true
      t.decimal :amount, null:false
      t.integer :reason, null:false

      t.timestamps null: false
    end
  end
end
