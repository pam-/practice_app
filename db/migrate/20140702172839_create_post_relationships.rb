class CreatePostRelationships < ActiveRecord::Migration
  def change
    create_table :post_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :post_relationships, :follower_id
    add_index :post_relationships, :followed_id
    add_index :post_relationships, [:follower_id, :followed_id], unique: true
  end
end
