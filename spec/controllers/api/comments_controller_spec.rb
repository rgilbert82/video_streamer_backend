require 'rails_helper'

describe Api::CommentsController do
  describe "GET chat_index" do
    let(:channel1) { Fabricate(:channel) }
    let(:video1)   { Fabricate(:video, id: '1', channel: channel1) }
    let(:user1)    { Fabricate(:user, id: '1') }
    let(:chat1)    { Fabricate(:chat, id: '1', video: video1)}
    let(:comment1) { Fabricate(:comment, id: '1', chat: chat1, user: user1)}

    it "responds with a 200 status" do
      mock = double()
      expect(mock).to receive(:items) { 1 }
      expect(mock).to receive(:next_page_token) { '12345' }
      expect(mock).to receive(:polling_interval_millis) { 3000 }

      allow_any_instance_of(Api::CommentsController).to receive(:fetch_comments_data_from_youtube)
        .and_return(mock)

      allow_any_instance_of(Api::CommentsController).to receive(:collect_new_comments).and_return([comment1])

      get :chat_index, params: { id: chat1.id }, format: :json
      expect(response.status).to eq(200)
    end
  end
end
