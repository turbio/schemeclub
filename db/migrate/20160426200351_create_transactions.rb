class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :from, index: true, foreign_key: true, null:false
      t.references :to, index: true, foreign_key: true, null:false
      t.integer :amount, null:false
      t.integer :reason, null:false

      t.timestamps null: false
    end
  end
end
