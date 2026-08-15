class AddUserToPosts < ActiveRecord::Migration[8.0]
  def up
    add_reference :posts, :user, foreign_key: true

    owner_id = User.order(:created_at).first&.id
    Post.update_all(user_id: owner_id) if owner_id

    change_column_null :posts, :user_id, false
  end

  def down
    remove_reference :posts, :user, foreign_key: true
  end
end
