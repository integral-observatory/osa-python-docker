#!/bin/bash

sed "s/ARG REGISTRY=scidockreg.esac.esa.int:62530//" Dockerfile > Dockerfile.tmp
sed "s+${REGISTRY}/datalabs/++" Dockerfile.tmp > Dockerfile_test
echo "COPY run_simplified.sh /opt/run_simplified.sh" >> Dockerfile_test

rm Dockerfile.tmp

docker build --progress plain --network=host -f Dockerfile_test -t osa-python-test:latest .
