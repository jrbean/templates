remove_file "Gemfile"
run "touch Gemfile"

add_source 'https://rubygems.org'


gem 'rails', '4.2.4'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem "devise"
gem "pg"
gem "twitter-bootstrap-rails"
gem "bootstrap_form"

gem "figaro"
gem "httparty"

gem_group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "pry-rails"
  gem "quiet_assets"
end

inside 'config' do
  remove_file 'database.yml'
  create_file 'database.yml' do <<-EOF
default: &default
  adapter: postgresql
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: #{app_name}_dev

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: #{app_name}_test

production:
  <<: *default
  database: #{app_name}_prod

EOF
  end
end

after_bundle do
  generate "devise:install"
  generate "devise", "User"

  generate "bootstrap:install", "static"
  generate "bootstrap:layout"

  rake "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit'}
end
