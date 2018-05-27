require 'rails_helper'

describe Channel do
  it { should have_many(:videos).dependent(:destroy) }
  it { should validate_presence_of(:title) }
end
