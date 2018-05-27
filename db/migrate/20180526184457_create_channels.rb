class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels, id: :string do |t|
      t.string :title
      t.timestamps
    end
  end
end
