source 'https://rubygems.org'
ruby '2.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.0.1'
gem 'puma', '~> 3.12'
gem 'rack-cors'
gem 'google-api-client'
gem 'jwt'
gem 'responders'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-nav'
  gem 'dotenv-rails'
  gem 'sqlite3'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'faker'
  gem 'fabrication'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rails_12factor', group: [:staging, :production]
