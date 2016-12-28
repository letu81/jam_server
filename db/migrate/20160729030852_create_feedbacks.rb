class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer  "user_id"
      t.text     "content"
      t.string   "contact"

      t.timestamps null: false
    end
  end
end