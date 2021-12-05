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
	VERSION=1.14
endif

clean ::
	$(call rm_image,1.14)

pull ::
	$(call pull_image,alpine)

lint ::
	$(call lint_dockerfile,Dockerfile)

build ::
	$(call build_image,Dockerfile,1.14)

test ::
	$(call test_container,1.14)

tag ::
	$(call tag_image,1.14)

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
