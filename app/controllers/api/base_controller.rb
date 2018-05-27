class Api::BaseController < ApplicationController
  respond_to :json

  private

  def get_service
    @service     = Google::Apis::YoutubeV3::YouTubeService.new
    @service.key = ENV['API_KEY']
    @service
  end
end
