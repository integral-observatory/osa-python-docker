#!/bin/bash

source /init.sh

export CURRENT_IC=/arc/
export INTEGRAL_DATA=/arc/

#dda-run ii_skyimage -m ddosa -a 'ddosa.ScWData(input_scwid="066500220010.001")' || echo "this fails with no data"
dda-run GRcat -m ddosa 
