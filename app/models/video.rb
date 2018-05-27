class Video < ApplicationRecord
  belongs_to :channel
  has_many   :chats, dependent: :destroy
  validates_presence_of :title
end
