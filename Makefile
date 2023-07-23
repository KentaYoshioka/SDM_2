setup:
	bundle install
	rm config/credentials.yml.enc
	EDITOR="mate --wait" bin/rails credentials:edit
	bundle exec rails db:migrate RAILS_ENV=production
	RAILS_ENV=production bin/rails assets:precompile
	read -p "Enter username: " username && read -p "Enter password: " password && echo "BASIC_AUTH_USER=$$username" > .env && echo "BASIC_AUTH_PASSWORD=$$password" >> .env

import:
	bundle exec rails import:all RAILS_ENV=production

start:
	bundle exec rails server -b 0.0.0.0 --environment=production

develop:
	bundle install
	bundle exec rails db:migrate
	read -p "Enter username: " username && read -p "Enter password: " password && echo "BASIC_AUTH_USER=$$username" > .env && echo "BASIC_AUTH_PASSWORD=$$password" >> .env
	bundle exec rails import:all


