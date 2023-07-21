setup:
	bundle install
	bundle exec rails db:migrate
	read -p "Enter username: " username && read -p "Enter password: " password && echo "BASIC_AUTH_USER=$$username" > .env && echo "BASIC_AUTH_PASSWORD=$$password" >> .env && echo "Credentials set: USERNAME=$$username, PASSWORD=$$password"
	include .env

import:
	bundle exec rails import:all

start:
	bundle exec rails server -b 0.0.0.0

down:
	docker compose down --rmi all --volumes

