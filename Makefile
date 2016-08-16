DOCKER := docker
VERSIONS ?= 1.6.2 1.6.3 1.7.0 1.7.1

generate: clean
	$(DOCKER) run --rm -ti -v $(PWD):/source -w /source debian:jessie bash update.sh ${VERSIONS}

clean:
	rm -rf ${VERSIONS}

hash-update:
	$(DOCKER) run --rm -ti -v $(PWD):/source -e VERSION=${VERSION} wordpress:4-apache /source/compute.sh