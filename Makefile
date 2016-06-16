DOCKER := docker
VERSIONS ?= 1.6.2 1.6.3

generate: clean
	$(DOCKER) run -ti -v $(PWD):/source -w /source debian:jessie bash update.sh ${VERSIONS}

clean:
	rm -rf ${VERSIONS}
