clean ::
	docker image rm golang-make

lint ::
	docker run --rm -i \
		-v "${PWD}"/.hadolint.yaml:/bin/hadolint.yaml \
		-e XDG_CONFIG_HOME=/bin hadolint/hadolint \
		< Dockerfile

build ::
	docker build -t golang-make .

shell ::
	docker run --rm -it --entrypoint=busybox golang-make sh

run ::
	docker run --rm -it golang-make

tag ::
	docker tag golang-make prantlf/golang-make:latest

login ::
	docker login --username=prantlf

push ::
	docker push prantlf/golang-make:latest
