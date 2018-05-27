class Comment < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  validates_presence_of :message
end
