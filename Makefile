init: copy-env docker-network-create-if-not-exists docker-down docker-up-build docker-composer-install docker-app-key-generate docker-migrations docker-chmod-storage docker-chmod-cache
up: docker-up
down: docker-down
restart: down up

copy-env:
	cp .env.example .env && \
	cp ./gateway/.env.example ./gateway/.env && \
	cp ./users/.env.example ./users/.env && \
	cp ./files_uploader/.env.example ./files_uploader/.env && \
	cp ./files_downloader/.env.example ./files_downloader/.env && \
	cp ./files_lists/.env.example ./files_lists/.env

docker-up:
	docker-compose -f ./docker-compose.yml up -d && \
	docker-compose -f ./gateway/docker-compose.yml up -d && \
	docker-compose -f ./users/docker-compose.yml up -d && \
	docker-compose -f ./files_uploader/docker-compose.yml up -d && \
	docker-compose -f ./files_downloader/docker-compose.yml up -d && \
 	docker-compose -f ./files_lists/docker-compose.yml up

docker-up-build:
	docker-compose -f ./docker-compose.yml up --build -d  && \
	docker-compose -f ./gateway/docker-compose.yml up --build -d  && \
	docker-compose -f ./users/docker-compose.yml up --build -d  && \
	docker-compose -f ./files_uploader/docker-compose.yml up --build -d  && \
	docker-compose -f ./files_downloader/docker-compose.yml up --build -d  && \
	docker-compose -f ./files_lists/docker-compose.yml up --build -d

docker-down:
	docker-compose down

docker-network-create-if-not-exists:
	docker network inspect microservices >/dev/null 2>&1 || docker network create --driver bridge microservices

docker-composer-install:
	docker-compose -f ./gateway/docker-compose.yml exec gateway composer install && \
	docker-compose -f ./users/docker-compose.yml exec users composer install && \
	docker-compose -f ./files_uploader/docker-compose.yml exec files_uploader composer install && \
	docker-compose -f ./files_downloader/docker-compose.yml exec files_downloader composer install && \
 	docker-compose -f ./files_lists/docker-compose.yml exec files_lists composer install

docker-app-key-generate:
	docker-compose -f ./gateway/docker-compose.yml exec gateway php artisan key:generate && \
	docker-compose -f ./users/docker-compose.yml exec users php artisan key:generate && \
	docker-compose -f ./files_uploader/docker-compose.yml exec files_uploader php artisan key:generate && \
	docker-compose -f ./files_downloader/docker-compose.yml exec files_downloader php artisan key:generate && \
 	docker-compose -f ./files_lists/docker-compose.yml exec files_lists php artisan key:generate

docker-migrations:
	docker-compose -f ./users/docker-compose.yml exec users php artisan migrate:fresh && \
	docker-compose -f ./files_uploader/docker-compose.yml exec files_uploader php artisan migrate:fresh && \
	docker-compose -f ./files_downloader/docker-compose.yml exec files_downloader php artisan migrate:fresh && \
 	docker-compose -f ./files_lists/docker-compose.yml exec files_lists php artisan migrate:fresh

docker-chmod-storage:
	docker-compose -f ./gateway/docker-compose.yml exec gateway chmod -R 777 storage && \
	docker-compose -f ./users/docker-compose.yml exec users chmod -R 777 storage && \
	docker-compose -f ./files_uploader/docker-compose.yml exec files_uploader chmod -R 777 storage && \
	docker-compose -f ./files_downloader/docker-compose.yml exec files_downloader chmod -R 777 storage && \
 	docker-compose -f ./files_lists/docker-compose.yml exec files_lists chmod -R 777 storage

docker-chmod-cache:
	docker-compose -f ./gateway/docker-compose.yml exec gateway chmod -R 777 bootstrap/cache && \
	docker-compose -f ./users/docker-compose.yml exec users chmod -R 777 bootstrap/cache && \
	docker-compose -f ./files_uploader/docker-compose.yml exec files_uploader chmod -R 777 bootstrap/cache && \
	docker-compose -f ./files_downloader/docker-compose.yml exec files_downloader chmod -R 777 bootstrap/cache && \
 	docker-compose -f ./files_lists/docker-compose.yml exec files_lists chmod -R 777 bootstrap/cache