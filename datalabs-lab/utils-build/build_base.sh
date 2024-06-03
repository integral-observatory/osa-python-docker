#!/bin/bash
docker build --progress plain --network=host -f Dockerfile-base-datalabs -t jl_base:stable-20.4 .
