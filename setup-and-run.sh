#!/bin/bash

if [[ "$JUPYTERHUB_USER" == course* ]]; then
  jupyter nbextension enable --sys-prefix create_assignment/main
  jupyter nbextension enable --sys-prefix formgrader/main --section=tree
  jupyter serverextension enable --sys-prefix nbgrader.server_extensions.formgrader
fi

. /usr/local/bin/start-singleuser.sh
