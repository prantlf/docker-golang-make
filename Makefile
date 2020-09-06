define rm_image
	docker image rm golang-make:$(1)
endef

define pull_image
	docker pull golang:$(1)
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
endef

define test_container
	docker run --rm -v "${PWD}":/work -w /work golang-make:$(1) echo VERSION=$(1)
endef

define tag_image
	docker tag golang-make:$(1) prantlf/golang-make:$(1)
endef

define push_image
	docker push prantlf/golang-make:$(1)
endef

ifeq ($(VERSION),)
  VERSION=latest
endif

clean ::
	$(call rm_image,1.14) || $(call rm_image,1.15) || $(call rm_image,latest)
	$(call rm_image,1.15) || $(call rm_image,latest)
	$(call rm_image,latest)

pull ::
	$(call pull_image,1.14-alpine)
	$(call pull_image,1.15-alpine)
	$(call pull_image,alpine)

lint ::
	$(call lint_dockerfile,Dockerfile.1.14)
	$(call lint_dockerfile,Dockerfile.1.15)
	$(call lint_dockerfile,Dockerfile)

build ::
	$(call build_image,Dockerfile.1.14,1.14)
	$(call build_image,Dockerfile.1.15,1.15)
	$(call build_image,Dockerfile,latest)

test ::
	$(call test_container,1.14)
	$(call test_container,1.15)
	$(call test_container,latest)

tag ::
	$(call tag_image,1.14)
	$(call tag_image,1.15)
	$(call tag_image,latest)

echo ::
	@echo "$(VERSION) works"

shell ::
	docker run --rm -it --entrypoint=busybox golang-make:$(VERSION) sh

run ::
	docker run --rm -it -v "${PWD}":/work -w /work golang-make:$(VERSION)

login ::
	docker login --username=prantlf

push ::
	$(call push_image,1.14)
	$(call push_image,1.15)
	$(call push_image,latest)
