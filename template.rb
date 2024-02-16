def rspec_setup
    generate "rspec:install"

    # Append requires to spec/rails_helper.rb
    append_to_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do
      <<~RUBY
  
        # Added by template
        require 'capybara/rspec'
        require 'faker'
        require 'support/database_cleaner' # Uncomment this line if you have a support file for DatabaseCleaner
      RUBY
    end

    dirname = File.basename(Dir.getwd)
    puts "dirname: #{dirname}"
    puts "__dir__: #{__dir__}"
    
    directory "#{__dir__}/rspec/support", "rspec/support"
end
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
after_bundle do
    rspec_setup
end
