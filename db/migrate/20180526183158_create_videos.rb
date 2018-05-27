class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos, id: :string do |t|
      t.string :channel_id
      t.string :title
      t.string :thumbnail
      t.text   :description
      t.string :published_at
      t.timestamps
    end
  end
end
