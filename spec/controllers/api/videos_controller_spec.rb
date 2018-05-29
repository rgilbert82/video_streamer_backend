require 'rails_helper'

describe Api::VideosController do
  describe "GET index" do
    it "responds with a 200 status" do
      mock = double()
      expect(mock).to receive(:items) { 1 }

      allow_any_instance_of(Api::VideosController).to receive(:fetch_channel_data_from_youtube)
        .and_return(mock)

      allow_any_instance_of(Api::VideosController).to receive(:collect_videos).and_return({items: 'Hello '})

      get :index, format: :json
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    let(:channel1) { Fabricate(:channel) }
    let(:video1)   { Fabricate(:video, id: '1', channel: channel1) }

    it "responds with a 200 status" do
      allow_any_instance_of(Api::VideosController).to receive(:fetch_video_from_db)
        .with('1').and_return(video1)

      get :show, params: { id: 1 }, format: :json
      expect(response.status).to eq(200)
    end
  end

  describe "GET stats" do
    let(:channel1) { Fabricate(:channel) }
    let(:video1)   { Fabricate(:video, id: '1', channel: channel1) }

    it "responds with a 200 status" do
      get :stats, params: { id: video1.id }, format: :json
      expect(response.status).to eq(200)
    end
  end
end
