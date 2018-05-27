class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates_presence_of :username
end
