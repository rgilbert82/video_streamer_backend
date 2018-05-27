class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats, id: :string do |t|
      t.string :video_id
      t.timestamps
    end
  end
end
