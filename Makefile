OSA_PLATFORM?=CentOS_7.8.2003_x86_64
#https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-binary-tarball/CentOS_7.8.2003_x86_64/latest/build-latest/builder-info.yml
OSA_VERSION?=$(shell curl https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-tarball/$(OSA_PLATFORM)/latest/latest/osa-version-ref.txt)
ISDC_REF_CAT_VERSION?=43.0
PYTHON_VERSION=3.10.11
HEASOFT_VERSION=6.33

OSA_IMAGE_TAG=${OSA_VERSION}-refcat-${ISDC_REF_CAT_VERSION}
IMAGE_TAG=${OSA_VERSION}-refcat-${ISDC_REF_CAT_VERSION}-heasoft-$(HEASOFT_VERSION)-python-$(PYTHON_VERSION)

IMAGE_BASE?=integralsw/osa-python

IMAGE?=$(IMAGE_BASE):$(IMAGE_TAG)
IMAGE_LATEST?=$(IMAGE_BASE):latest

DUSER := $(shell id -u)

push: build
	docker push $(IMAGE) 
	docker push $(IMAGE_LATEST) 

build: Dockerfile
	docker build --progress plain --build-arg OSA_VERSION=$(OSA_VERSION) --build-arg python_version=$(PYTHON_VERSION) --build-arg heasoft_version=$(HEASOFT_VERSION) . -t $(IMAGE) 
	docker build --build-arg OSA_VERSION=$(OSA_VERSION) --build-arg python_version=$(PYTHON_VERSION) --build-arg heasoft_version=$(HEASOFT_VERSION) . -t $(IMAGE_LATEST)

squash:
	docker build --squash --build-arg OSA_VERSION=$(OSA_VERSION) --build-arg python_version=$(PYTHON_VERSION) --build-arg heasoft_version=$(HEASOFT_VERSION) . -t $(IMAGE)-squashed 
	docker build --squash --build-arg OSA_VERSION=$(OSA_VERSION) --build-arg python_version=$(PYTHON_VERSION) --build-arg heasoft_version=$(HEASOFT_VERSION) . -t $(IMAGE_LATEST)-squashed 
	

pull:
	docker pull $(IMAGE) 
	docker pull $(IMAGE_LATEST) 

#Dockerfile: Dockerfile.j2
#	j2 -e 'OSA_VERSION="$(OSA_IMAGE_TAG)"' Dockerfile.j2 -d -o Dockerfile

jupyter: 
	docker run -e DISPLAY=${DISPLAY} -v $(PWD):/home/jovyan -v /etc/passwd:/etc/passwd -it --entrypoint='' -v /tmp/.X11-unix:/tmp/.X11-unix -v ${HOME}/.Xauthority:/home/jovyan/.Xauthority:rw --net=host --user $(DUSER) $(IMAGE) bash -c 'export HOME_OVERRRIDE=/tmp; source /init.sh; jupyter notebook --ip 0.0.0.0 --no-browser --port=1234'

test:
	mkdir -p /tmp/test_integralsw
	docker run -it --net=host --user $(shell id -u) -v /tmp/test_integralsw:/home/jovyan --entrypoint="" $(IMAGE) bash -c 'cd /tests; ls -ltor; make'

squash: build
	docker build --build-arg IMAGE_NAME=$(IMAGE) . -t $(IMAGE)-noentry -f Dockerfile-noentry

singularity: squash
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}:/output --privileged -t --rm quay.io/singularity/docker2singularity $(IMAGE)-noentry

