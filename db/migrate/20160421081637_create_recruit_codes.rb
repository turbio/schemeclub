class CreateRecruitCodes < ActiveRecord::Migration
  def change
    create_table :recruit_codes do |t|
      t.references :owner, index: true, foreign_key: true, null: false
      t.string :code, null: false
      t.boolean :claimed, null: false

      t.timestamps null: false
    end
  end
end
