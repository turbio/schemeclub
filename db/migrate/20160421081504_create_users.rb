class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :superior, index: true, foreign_key: true, null: false
      t.string :name, null: false
      t.string :password, null: false

      t.timestamps null: false
    end
  end
end
