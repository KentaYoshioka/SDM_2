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

docker-up:
	docker compose up -d

docker-setup:
	docker compose build
	docker compose exec myapp bash -c 'bundle exec rails db:migrate'
	docker compose exec myapp bash -c 'bundle exec rake import:all'
	docker compose exec myapp bash -c 'read -p "Enter username: " username && read -p "Enter password: " password && echo "BASIC_AUTH_USER=$$username" > .env && echo "BASIC_AUTH_PASSWORD=$$password" >> .env && echo "Credentials set: USERNAME=$$username, PASSWORD=$$password"'
	docker compose up -d

docker-start:
	docker compose exec myapp bash -c 'bundle exec rails server -b 0.0.0.0'



