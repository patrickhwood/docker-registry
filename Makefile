all: registry registry_flat

registry: .registry

.registry: Dockerfile
	-docker rmi -f registry
	docker build --force-rm=true --tag=registry .
	touch .registry

registry_flat: .registry_flat

.registry_flat: .registry
	-docker rmi -f registry:flat
	-docker rm -f registry_flat
	docker create --name=registry_flat registry
	docker export registry_flat | docker import -c='ENV DOCKER_REGISTRY_CONFIG /docker-registry/config/config_sample.yml' -c='CMD ["docker-registry"]' - registry:flat
	docker rm registry_flat
	touch .registry_flat
