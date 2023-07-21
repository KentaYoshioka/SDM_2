setup:
	bundle install
	rm config/credentials.yml.enc
	EDITOR="mate --wait" bin/rails credentials:edit
	bundle exec rails db:migrate RAILS_ENV=production
	read -p "Enter username: " username && read -p "Enter password: " password && echo "BASIC_AUTH_USER=$$username" > .env && echo "BASIC_AUTH_PASSWORD=$$password" >> .env && echo "Credentials set: USERNAME=$$username, PASSWORD=$$password"

import:
	bundle exec rails import:all

start:
	bundle exec rails server -b 0.0.0.0 --environment=production

down:
	docker compose down --rmi all --volumes

