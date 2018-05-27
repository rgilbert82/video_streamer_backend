require 'rails_helper'

describe Comment do
  it { should belong_to(:chat) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:message) }
end
