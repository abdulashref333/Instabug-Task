source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"

  # Add a comment summarizing the current schema to the top or bottom of each of your...
  # ActiveRecord models
  # Tests and Specs
  # .........
  # [https://github.com/ctran/annotate_models]
  gem "annotate", "~> 3.2"

  # Solargraph provides a comprehensive suite of tools for Ruby programming: intellisense, diagnostics, inline documentation, and type checking
  gem 'solargraph'
end

group :test do
  # A drop-in alternative to its default testing framework, Minitest. [https://github.com/rspec/rspec-rails]
  gem "rspec-rails", "~> 5.1"

  # Provides RSpec- and Minitest-compatible one-liners to test common Rails functionality that, if written by hand, would be much longer, more complex, and error-prone [https://github.com/thoughtbot/shoulda-matchers]
  gem "shoulda-matchers", "~> 5.1"
end

group :development, :test, :integration do
  # Generates fake data [https://github.com/ffaker/ffaker]
  gem "ffaker", "~> 2.21"

  # A fixtures replacement with a straightforward definition syntax [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails", "~> 6.2"
end

gem 'dotenv-rails', groups: [:development, :test]