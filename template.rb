def database_setup
    # Setup database
    run "rails db:create"
    run "rails db:migrate"
end

def devise_setup
    generate "devise:install"
    generate "devise", "User"

    # Add mailer detail to development.rb
    append_to_file 'config/environments/development.rb', after: "config.action_mailer.perform_caching = false\n" do
        <<~RUBY
        config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
        RUBY
    end
    
    # Generate a placeholder home controller
    generate :controller, "home", "index"
    route "root to: 'home#index'"

    # Add devise params to application controller
    inject_into_file 'app/controllers/application_controller.rb', before: "after_action :verify_policy_scoped" do
        <<~RUBY
        after_action :verify_authorized
        RUBY
    end

    # Skip Pundit checks on the HomeController
    inject_into_file 'app/controllers/home_controller.rb', after: "class HomeController < ApplicationController\n" do
        <<~RUBY
        skip_after_action :verify_authorized
        skip_after_action :verify_policy_scoped
        RUBY
    end
end


def pundit_setup
    generate "pundit:install"
    directory "#{__dir__}/app/policies","app/policies", force: true

    # Add pundit to the application controller
    inject_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do
        <<~RUBY
        include Pundit::Authorization

        rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

        after_action :verify_policy_scoped
      
        def user_not_authorized
            flash[:alert] = "You are not authorized to perform this action."
            redirect_to(request.referrer || root_path)
        end
        RUBY
    end
        
end

def roles_setup
    inject_into_class 'app/models/user.rb', 'User' do
        <<~RUBY
            include RoleModel
            
            roles_attribute :roles_mask
            roles :admin, prefix: "is_"
        RUBY
    end

    generate(:migration, "AddRolesMaskToUsers", "roles_mask:integer")
end

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
    directory "#{__dir__}/spec/support", "spec/support"
end


remove_file "public/index.html"
remove_file "public/favicon.ico"
remove_file "public/images/rails.png"
remove_file "public/robots.txt"

gem "devise"
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
    pundit_setup
    devise_setup
    roles_setup
    database_setup
end



