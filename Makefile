.SILENT :
.PHONY : test-debian test-alpine test

REGISTRY = docker.io
# DOCKER_PWD is set in travis-ci
# DOCKER_USER is set in travis-ci

update-dependencies:
	test/requirements/build.sh

test-debian: update-dependencies
	docker build --no-cache -t aptrust/nginx-proxy:test .
	test/pytest.sh

test-alpine: update-dependencies
	docker build --no-cache -f Dockerfile.alpine -t aptrust/nginx-proxy:test .
	test/pytest.sh

test: test-debian test-alpine

build:
	docker build --no-cache -f Dockerfile.alpine -t aptrust/nginx-proxy .

release:
	docker login
	docker build --no-cache -f Dockerfile.alpine -t aptrust/nginx-proxy .
	docker push aptrust/nginx-proxy

release-ci:
	@echo ${DOCKER_PWD} | docker login -u ${DOCKER_USER} --password-stdin $(REGISTRY)
	docker build --no-cache -f Dockerfile.alpine -t aptrust/nginx-proxy .
	docker push aptrust/nginx-proxy
