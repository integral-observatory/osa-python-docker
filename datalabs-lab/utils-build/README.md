Dockerfile-base-datalabs is a Dockerfile that emulates the base Datalabs
`build_base.sh` is building the base image as in Datalabs
`build_test.sh` it builds a test dontainer in local modifying the Dockerfile (run it from folder below)
`launch_lab.sh` launches the test container locally 
`
IMAGE=osa-python-test:latest ./launch_lab.sh
`
`run.sh` is a copy of the startup script in Datalabs
`run_simplified.sh` is the above without the Datalabs infrastructure for local testing
`update_versions.sh` is a script to check and test local versions of packages

It is better to make a preliminary Dockerfile without versions and then infer them from the container.

`zip osa-python-lab.zip activate.sh datalab-meta.yml Dockerfile init.sh tests` will zip the essential files

