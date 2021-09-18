init: copy-env docker-down docker-up-build-d docker-app-key-generate docker-init-queue docker-migrations docker-chmod-storage docker-chmod-cache
up: docker-up
down: docker-down
stop: docker-stop
start: docker-start
restart: down up
up-d: docker-up-d
call: docker-call

composes := $(sort $(shell find . -maxdepth 2 -regex '.*\(000-root-\)?docker-compose\.yml$$'))
merged_compose_file := $(addprefix -f , $(composes))
envs := $(shell find . -maxdepth 2 -name ".env.example")

copy-env:
	$(foreach path,$(envs),cp $(path) $(subst .env.example,.env,$(path));)

docker-up:
	docker-compose $(merged_compose_file) up

docker-up-d:
	docker-compose $(merged_compose_file) up -d

docker-up-build:
	docker-compose $(merged_compose_file) up --build

docker-up-build-d:
	docker-compose $(merged_compose_file) up --build -d

docker-down:
	docker-compose $(merged_compose_file) down

docker-stop:
	docker-compose $(merged_compose_file) stop ${c}

docker-start:
	docker-compose $(merged_compose_file) start ${c}

docker-init-queue:
	docker-compose $(merged_compose_file) exec files_lists php artisan rabbitmq:queue-declare default && \
	docker-compose $(merged_compose_file) restart worker_queue

docker-app-key-generate:
	docker-compose $(merged_compose_file) exec gateway php artisan key:generate && \
	docker-compose $(merged_compose_file) exec users php artisan key:generate && \
	docker-compose $(merged_compose_file) exec files_uploader php artisan key:generate && \
	docker-compose $(merged_compose_file) exec files_downloader php artisan key:generate && \
 	docker-compose $(merged_compose_file) exec files_lists php artisan key:generate

docker-migrations:
	docker-compose $(merged_compose_file) exec users php artisan migrate:fresh && \
	docker-compose $(merged_compose_file) exec files_uploader php artisan migrate:fresh && \
	docker-compose $(merged_compose_file) exec files_downloader php artisan migrate:fresh && \
 	docker-compose $(merged_compose_file) exec files_lists php artisan migrate:fresh

docker-chmod-storage:
	docker-compose $(merged_compose_file) exec gateway chmod -R 777 storage && \
	docker-compose $(merged_compose_file) exec users chmod -R 777 storage && \
	docker-compose $(merged_compose_file) exec files_uploader chmod -R 777 storage && \
	docker-compose $(merged_compose_file) exec files_downloader chmod -R 777 storage && \
 	docker-compose $(merged_compose_file) exec files_lists chmod -R 777 storage

docker-chmod-cache:
	docker-compose $(merged_compose_file) exec gateway chmod -R 777 bootstrap/cache && \
	docker-compose $(merged_compose_file) exec users chmod -R 777 bootstrap/cache && \
	docker-compose $(merged_compose_file) exec files_uploader chmod -R 777 bootstrap/cache && \
	docker-compose $(merged_compose_file) exec files_downloader chmod -R 777 bootstrap/cache && \
	docker-compose $(merged_compose_file) exec files_lists chmod -R 777 bootstrap/cache

docker-call:
	docker-compose $(merged_compose_file) ${c}