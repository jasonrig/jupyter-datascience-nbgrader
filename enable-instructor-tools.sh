#!/bin/bash

if [[ "$JUPYTERHUB_USER" == course* ]]; then
  jupyter nbextension enable --user create_assignment/main
  jupyter nbextension enable --user formgrader/main --section=tree
  jupyter serverextension enable --user nbgrader.server_extensions.formgrader
fi
