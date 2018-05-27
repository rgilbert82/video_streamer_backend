class Channel < ApplicationRecord
  has_many :videos, dependent: :destroy
  validates_presence_of :title
end
