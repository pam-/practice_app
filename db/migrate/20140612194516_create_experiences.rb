class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :experiences, [:user_id, :created_at]
  end
end
