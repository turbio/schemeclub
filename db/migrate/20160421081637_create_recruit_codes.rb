class CreateRecruitCodes < ActiveRecord::Migration
  def change
    create_table :recruit_codes do |t|
      t.references(
        :owner,
        references: :user,
        index: true,
        null: false
      );

      t.string :code, null: false
      t.boolean :claimed, null: false

      t.timestamps null: false
    end
    add_foreign_key :recruit_codes, :users, column: :owner_id
  end
end
