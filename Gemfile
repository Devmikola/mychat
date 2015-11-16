source 'https://rubygems.org'
ruby '2.1.5'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.1.8'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'guard-rspec'

  gem 'spork-rails'
  gem 'guard-spork'
  gem 'childprocess'
end

group :test do
  gem 'selenium-webdriver'
  gem 'capybara'
  
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'gherkin'

  gem 'rb-notifu'
  gem 'factory_girl_rails'
# Minitest needed for rspec using throw the guard
  gem 'minitest'
  gem 'wdm'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
#gem 'sprockets-rails', '~>2.0.0'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-script-source', '1.8.0'
#gem 'coffee-rails', '4.0.1'
gem 'therubyracer',  platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

