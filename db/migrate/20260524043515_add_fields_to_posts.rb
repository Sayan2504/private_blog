class AddFieldsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :subtitle, :string
    add_column :posts, :author, :string
    add_column :posts, :published_at, :datetime
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true
  end
end
