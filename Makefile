define rm_image
	docker image rm golang-make:$(1) prantlf/golang-make:$(1) registry.gitlab.com/prantlf/docker-golang-make:$(1)
endef

define pull_image
	docker pull prantlf/golang-make:$(1)
	docker pull registry.gitlab.com/prantlf/docker-golang-make:$(1)
endef

define lint_dockerfile
	docker run --rm -i \
		-v "${PWD}"/.hadolint.yaml:/bin/hadolint.yaml \
		-e XDG_CONFIG_HOME=/bin hadolint/hadolint \
		< $(1)
endef

define build_image
	docker build -f $(1) -t golang-make .
	docker tag golang-make golang-make:$(2)
	docker tag golang-make:$(2) prantlf/golang-make:$(2)
endef

define test_container
	docker run --rm -v "${PWD}":/work -w /work golang-make:$(1) echo VERSION=$(1)
endef

define push_image
	docker tag prantlf/golang-make prantlf/golang-make:$(1)
	docker push prantlf/golang-make:$(1)
	docker tag registry.gitlab.com/prantlf/docker-golang-make registry.gitlab.com/prantlf/docker-golang-make:$(1)
	docker push registry.gitlab.com/prantlf/docker-golang-make:$(1)
endef

ifeq ($(VERSION),)
	VERSION=latest
endif

all :: lint build

clean ::
	$(call rm_image,latest)

pull ::
	$(call pull_image,latest)

lint ::
	$(call lint_dockerfile,Dockerfile)

build ::
	$(call build_image,Dockerfile,latest)

test ::
	$(call test_container,latest)

tag ::
	$(call tag_image,latest)

echo ::
	@echo "$(VERSION) works"

shell ::
	docker run --rm -it --entrypoint=busybox golang-make:$(VERSION) sh

run ::
	docker run --rm -it -v "${PWD}":/work -w /work golang-make:$(VERSION)

login ::
	docker login --username=prantlf
	docker login registry.gitlab.com --username=prantlf

push ::
	$(call push_image,$(VERSION))
