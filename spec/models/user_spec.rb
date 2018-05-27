require 'rails_helper'

describe User do
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of(:username) }
end
