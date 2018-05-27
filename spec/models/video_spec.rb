require 'rails_helper'

describe Video do
  it { should belong_to(:channel) }
  it { should have_many(:chats).dependent(:destroy) }
  it { should validate_presence_of(:title) }
end
