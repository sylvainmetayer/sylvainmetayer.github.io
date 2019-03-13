.DEFAULT_GOAL := up

LABEL = jekyll_docker_sylvainmetayer

CONTAINER_NAME = jekyll_sylvainmetayer
CONTAINER_NAME_PROD = jekyll_sylvainmetayer_production
DEPLOY_DIRECTORY = /var/www/sylvainmetayer.fr

DOCKER_EXEC = docker exec
DOCKER_COMPOSE = docker-compose

containers := $$(docker ps -af label=$(LABEL) -q)
images     := $$(docker images -af label=$(LABEL) -q)

build:
	$(DOCKER_COMPOSE) build

up: build
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

stop: 
	$(DOCKER_COMPOSE) stop

restart:
	$(DOCKER_COMPOSE) restart

test:
	$(DOCKER_EXEC) $(CONTAINER_NAME) bundle exec rake test

help:
	$(DOCKER_EXEC) $(CONTAINER_NAME) jekyll help

draft:
	$(DOCKER_EXEC) $(CONTAINER_NAME) jekyll draft $(name)

cleanup:
	rm -rf _site .jekyll-metadata .sass-cache .git-metadata .jekyll-cache

clean: down
	docker stop $(containers) || true
	docker rm -f $(containers) || true
	docker rmi -f $(images) || true
	rm -rf _site .jekyll-metadata .sass-cache .git-metadata .jekyll-cache

publish: 
	$(DOCKER_EXEC) $(CONTAINER_NAME) jekyll publish $(name)

logs:
	docker logs $(CONTAINER_NAME) -f 

logs-prod: 
	docker logs $(CONTAINER_NAME_PROD) -f 

deploy: 
	rsync -r --verbose --quiet --delete-after _site/* $(name):$(DEPLOY_DIRECTORY)
