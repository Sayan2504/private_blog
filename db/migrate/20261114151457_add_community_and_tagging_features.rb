class AddCommunityAndTaggingFeatures < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :tags, :slug, unique: true
    add_index :tags, :name, unique: true

    create_table :post_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :post_tags, %i[ post_id tag_id ], unique: true

    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
    add_index :bookmarks, %i[ user_id post_id ], unique: true

    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.integer :count, null: false, default: 1
      t.timestamps
    end
    add_index :reactions, %i[ user_id post_id ], unique: true

    add_column :posts, :reactions_count, :integer, null: false, default: 0

    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
    add_index :comments, %i[ post_id created_at ]
  end
end
