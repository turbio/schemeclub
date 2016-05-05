class AssociateTransactionsWithUsers < ActiveRecord::Migration
  def change
      create_table :users_transactions, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :transaction, index: true
    end
  end
end
