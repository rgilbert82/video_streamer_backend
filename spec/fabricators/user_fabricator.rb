Fabricator(:user) do
  username { Faker::Name.title }
  image_url 'http://image_url.com'
  youtube_url 'https://youtube.com'
end
