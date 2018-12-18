ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jason Rigby <hello@jasonrig.by>"

USER $NB_UID

RUN conda install --quiet --yes -c conda-forge nbgrader

RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader
RUN jupyter nbextension disable --sys-prefix create_assignment/main
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader

COPY enable-instructor-tools.sh /usr/local/bin/

USER root
RUN chmod 555 /usr/local/bin/enable-instructor-tools.sh
USER $NB_UID
