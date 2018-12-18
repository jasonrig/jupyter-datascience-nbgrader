#!/bin/bash
# Set the user name and UID to something more sensible
export NB_USER="$JUPYTERHUB_USER"
username_hash=$(echo $JUPYTERHUB_USER | sha256sum)
username_hash=${username_hash:0:7}
export NB_UID=$(printf "%d" 0x$username_hash)
ln -s /home/jovyan "/home/$NB_USER"
chown $NB_UID /home/jovyan

whoami > /tmp/me

/usr/local/bin/start-singleuser.sh $*
