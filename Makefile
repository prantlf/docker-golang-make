clean ::
	docker image rm golang-make

lint ::
	docker run --rm -i \
		-v "${PWD}"/.hadolint.yaml:/bin/hadolint.yaml \
		-e XDG_CONFIG_HOME=/bin hadolint/hadolint \
		< Dockerfile.1.14
	docker run --rm -i \
		-v "${PWD}"/.hadolint.yaml:/bin/hadolint.yaml \
		-e XDG_CONFIG_HOME=/bin hadolint/hadolint \
		< Dockerfile

build ::
	docker build -f Dockerfile.1.14 -t golang-make .
	docker tag golang-make prantlf/golang-make:1.14
	docker build -t golang-make .
	docker tag golang-make prantlf/golang-make:latest

shell ::
	docker run --rm -it --entrypoint=busybox golang-make sh

run ::
	docker run --rm -it golang-make

login ::
	docker login --username=prantlf

push ::
	docker push prantlf/golang-make:1.14
	docker push prantlf/golang-make:latest
