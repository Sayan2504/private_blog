class AddModernizationAndSocialFeatures < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :scheduled_for, :datetime
    add_index :posts, :scheduled_for

    add_column :posts, :search_vector, :tsvector
    add_index :posts, :search_vector, using: :gin

    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :follows, %i[ follower_id followed_id ], unique: true

    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :notifiable, polymorphic: true, null: false
      t.string :action, null: false
      t.datetime :read_at
      t.timestamps
    end
    add_index :notifications, %i[ recipient_id read_at ]
  end
end
