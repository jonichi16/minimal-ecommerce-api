source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0.6"

gem "api_guard"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "jsonapi-serializer"
gem "pg", "~> 1.5"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 6.0", ">= 6.0.1"
end

group :development do
  gem "rubocop", "~> 1.50", ">= 1.50.2", require: false
  gem "rubocop-performance", "~> 1.17", require: false
  gem "rubocop-rails", "~> 2.19", require: false
  gem "rubocop-rspec", "~> 2.22", require: false
end

group :test do
  gem "capybara", "~> 3.39"
  gem "shoulda-matchers", "~> 5.3"
  gem "webdrivers", "~> 5.2"
end
