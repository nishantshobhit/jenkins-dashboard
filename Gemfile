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
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "haml", "~> 3.1.7"
end

# General

# js
gem 'jquery-rails'
gem "d3-rails", "~> 0.0.5"
gem 'json'

# requests
gem 'httparty'
gem "bcrypt-ruby", :require => "bcrypt"

# cron
gem 'whenever', :require => false

# foreman
gem "foreman"

# big brother is watching you
gem "spellchecker", "~> 0.1.5"

# capistrano
gem 'rvm-capistrano'

# passegner
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
  gem 'simplecov-rcov'
  gem 'simplecov'
  gem "rspec-rails"
  gem "spork"
  gem "guard-spork"
  gem "factory_girl_rails", "~> 4.0"
end
