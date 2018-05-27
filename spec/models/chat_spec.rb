require 'rails_helper'

describe Chat do
  it { should belong_to(:video) }
  it { should have_many(:comments).dependent(:destroy) }
end
