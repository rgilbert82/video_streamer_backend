Fabricator(:comment) do
  message { Faker::Name.title }
  published_at '2018-01-01'
end
