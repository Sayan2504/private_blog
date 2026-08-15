class RemoveOrphanedViewCountFromPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :view_count, :integer, default: 0, null: false if column_exists?(:posts, :view_count)
  end
end
