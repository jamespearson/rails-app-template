remove_file "public/index.html"
remove_file "public/favicon.ico"
remove_file "public/images/rails.png"
remove_file "public/robots.txt"

gem "pundit", "~> 2.3"
gem "role_model"
gem "sentry-ruby"
gem "sentry-rails"
gem "sidekiq"
gem "standardrb"
gem "standard-rails"

gem_group :development, :test do
    gem "capybara"
    gem "database_cleaner"
    gem "faker"
    gem "factory_bot_rails"
    gem "rspec_junit_formatter"
    gem "rspec-rails"
    gem "simplecov", require: false
    gem "shoulda"
end

gem_group :development do
    gem 'annotate'
end
