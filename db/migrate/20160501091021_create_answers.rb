class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id, null: false
      t.integer :survey_id, null: false
      t.text :inputs

      t.timestamps null: false
    end

    add_index :answers, [:user_id, :survey_id], unique: true
  end
end
