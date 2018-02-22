class AddItemsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :view_id, :string
    add_column :users, :image, :string
    add_column :users, :password, :string
    add_column :users, :access_token, :string
    add_column :users, :refresh_token, :string
    add_column :users, :oauth_expires_at, :string
  end
end
