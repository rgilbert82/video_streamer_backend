class Chat < ApplicationRecord
  belongs_to :video
  has_many   :comments, dependent: :destroy
end
