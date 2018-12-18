#!/bin/bash

if [[ "$JUPYTERHUB_USER" == course_* ]]; then
  jupyter nbextension enable --user create_assignment/main
  jupyter nbextension enable --user formgrader/main --section=tree
  jupyter serverextension enable --user nbgrader.server_extensions.formgrader
  cat << EOF >> "/home/$JUPYTERHUB_USER/.jupyter/nbgrader_config.py"
import os
c = get_config()
c.Exchange.course_id = os.environ['JUPYTERHUB_USER'].split('_')[-1].upper()

c = get_config()
c.ClearSolutions.code_stub = {
    "R": "# Write your code here",
    "python": "# Write your code here\nraise NotImplementedError",
}
EOF
fi
