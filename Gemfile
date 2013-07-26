source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'rake', '10.0.4'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# database
gem "pg"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'compass-rails'
end

# markup
gem "haml", "~> 3.1.7"
gem 'sass-rails',   '~> 3.2.3'
gem 'uglifier', '>= 1.0.3'

# js
gem 'therubyracer'
gem 'jquery-rails'
gem 'json'
gem 'coffee-rails', '~> 3.2.1'

# requests
gem 'httparty'
gem "bcrypt-ruby", :require => "bcrypt"

# cron
gem 'whenever', :require => false

# coveralls
gem 'coveralls', require: false

# foreman
gem "foreman"

# capistrano
gem 'rvm-capistrano'

# passenger
gem 'passenger'

# environment specific
group :development do
  gem 'guard'
  gem 'rb-readline'
  gem "guard-rspec"
  gem 'rb-fsevent', '~> 0.9.1'
  gem "pry"
  gem 'guard-livereload'
end

group :test do
  gem 'yarjuf'
  gem "rspec"
  gem "rspec-rails"
  gem "spork"
  gem "guard-spork"
  gem "factory_girl_rails", "~> 4.0"
end
