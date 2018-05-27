class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: :string do |t|
      t.string :username
      t.string :image_url
      t.string :youtube_url
      t.timestamps
    end
  end
end
