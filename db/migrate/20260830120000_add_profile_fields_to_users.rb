class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :address, :text
    add_column :users, :mobile_number, :string

    # A real array rather than a comma-joined string: interests are a list, and
    # storing them as one lets them be queried and counted later without
    # parsing. The default keeps `user.interests` an array for every existing
    # row, so nothing has to guard against nil.
    add_column :users, :interests, :string, array: true, default: [], null: false
  end
end
