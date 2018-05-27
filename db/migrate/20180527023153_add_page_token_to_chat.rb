class AddPageTokenToChat < ActiveRecord::Migration[5.0]
  def change
    add_column :chats, :page_token, :string
  end
end
