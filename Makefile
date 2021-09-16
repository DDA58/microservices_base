init: docker-network-create-if-not-exists docker-down docker-up-build
up: docker-up
down: docker-down
restart: down up

docker-up:
	docker-compose -f ./docker-compose.yml up & \
	docker-compose -f ./gateway/docker-compose.yml up & \
	docker-compose -f ./users/docker-compose.yml up & \
	docker-compose -f ./files_uploader/docker-compose.yml up & \
	docker-compose -f ./files_downloader/docker-compose.yml up & \
# 	docker-compose -f ./files_lists/docker-compose.yml up

docker-up-build:
	docker-compose -f ./docker-compose.yml up --build & \
	docker-compose -f ./gateway/docker-compose.yml up --build & \
	docker-compose -f ./users/docker-compose.yml up --build & \
	docker-compose -f ./files_uploader/docker-compose.yml up --build & \
	docker-compose -f ./files_downloader/docker-compose.yml up --build & \
	docker-compose -f ./files_lists/docker-compose.yml up --build

docker-down:
	docker-compose down

docker-network-create-if-not-exists:
	docker network inspect microservices >/dev/null 2>&1 || docker network create --driver bridge microservices
	

