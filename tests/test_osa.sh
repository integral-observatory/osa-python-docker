#!/bin/bash

source /init.sh

set -e

echo $ISDC_ENV

cat /init.sh

echo $PATH

ls -ltor /opt

ls -lotr $ISDC_ENV

ls -lotr $ISDC_ENV/bin

which ii_skyimage
plist ii_skyimage

ii_skyimage --help


