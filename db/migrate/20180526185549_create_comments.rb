class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments, id: :string do |t|
      t.string :chat_id
      t.string :user_id
      t.string :published_at
      t.text   :message
      t.timestamps
    end
  end
end
