#!/bin/bash
# ----------------------------------------------------------
# © Copyright 2021 European Space Agency, 2021
# This file is subject to the terms and conditions defined
# in file 'LICENSE.txt', which is part of this
# [source code/executable] package. No part of the package,
# including this file, may be copied, modified, propagated,
# or distributed except according to the terms contained in
# the file ‘LICENSE.txt’.
# -----------------------------------------------------------

. /.datalab/init.sh

wait_interface & # emit state change to API when the interface is ready

#Create user home directory as a symlink to the user persistent area volume (pending correction related to SEPPPCR-191).
ln -s /media/home /home/$USER
# chmod -R go+rwx /media/home/.local

cd $HOME

export JUPYTER_CONFIG_DIR=$HOME/.jupyterlab-$DATALAB_ID

JUPYTER_DEBUG=""
if [ "$LOG_LEVEL" == 'debug' ];then
    JUPYTER_DEBUG="--debug"
fi
debug "Start Jupyterlab server"

Xvfb :1 &
for f in /opt/datalabs/init.d/*.sh; do
  chown $UID:$UID $f
  chmod u+x $f
  su - $USER -c "bash +euo pipefail -cl \"HOME=/home/$USER $f\""
done

api_emit_running
if su - $USER -c " bash -cl \"HOME=/home/$USER /opt/miniconda/bin/jupyter lab --ip=0.0.0.0  $JUPYTER_DEBUG --port=$IF_main_port \
  --JupyterApp.config_file='/etc/jupyter_notebook_config.py' \
  --NotebookApp.base_url=\"/datalabs/$IF_main_id\" \
  --NotebookApp.token='' --NotebookApp.password=''\""
then
  api_emit_finished
else
  api_emit_error
fi

api_emit_if_done
