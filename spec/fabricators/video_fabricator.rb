Fabricator(:video) do
  title { Faker::Name.title }
  description 'Video Description'
  thumbnail 'http://google.com'
  published_at '2018-01-01'
end
