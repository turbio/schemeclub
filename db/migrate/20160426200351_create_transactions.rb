class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references(
        :from,
        references: :user,
        index: true,
        null: true
      )
      t.decimal :amount, null:false
      t.integer :reason, null:false

      t.timestamps null: false
    end

    add_foreign_key :transactions, :users, column: :from_id
  end
end
