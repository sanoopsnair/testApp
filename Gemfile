source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use sqlite3 as the database for Active Record
# gem 'mysql2', '~> 0.4.4'

gem 'sqlite3'

# Use Unicorn as the app server
gem 'unicorn', '~> 5.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'listen', '~> 3.0.5'

#gem 'poodle-rb', '~> 0.2.5'
#gem 'poodle-rb', path: "/Users/kpvarma/Projects/RightSolutions/Rails/poodle"

gem 'ruby-progressbar'
gem "colorize"

gem 'carrierwave'
gem 'fog'
gem 'rmagick', :require => 'rmagick'
gem 'jquery-fileupload-rails'

# Poodle Dependencies
gem "handy-css-rails", "0.0.7"
gem "kaminari"
#gem "bootstrap-kaminari-views"
#gem "bootstrap-datepicker-rails"
#gem "jquery-validation-rails"


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
end

group :test do
  gem "shoulda"
  #gem 'cucumber-rails', :require => false
  #gem 'cucumber-websteps'
  #gem 'pickle'
  #gem 'capybara'
  gem 'database_cleaner'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.4.1', '>= 3.4.1'
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-bundler', '~> 1.1.4'
  gem 'capistrano-nginx-unicorn', '~> 0.1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
