ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jason Rigby <hello@jasonrig.by>"

USER $NB_UID

RUN conda install --quiet --yes -c conda-forge jupyter_contrib_nbextensions
# https://github.com/apache/incubator-superset/issues/6977#issuecomment-469636503
RUN conda install --quiet --yes -c conda-forge nbgrader sqlalchemy==1.2.18
RUN conda install --quiet --yes \
    'r-testthat' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader
RUN jupyter nbextension disable --sys-prefix create_assignment/main
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader

COPY set-terminal-prompt.sh /etc/profile.d/
COPY enable-instructor-tools.sh /usr/local/bin/
COPY set-user-start-notebook.sh /usr/local/bin/
COPY start.sh /usr/local/bin/

USER root

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		libapparmor1 \
		libedit2 \
		lsb-release \
		psmisc \
		libssl1.0.0 \
		libclang-dev
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV RSTUDIO_PKG=rstudio-server-1.2.1335-amd64.deb
ENV SHINY_PKG=shiny-server-1.5.9.923-amd64.deb
ENV PATH="${PATH}:/usr/lib/rstudio-server/bin"

RUN wget -q https://download2.rstudio.org/server/bionic/amd64/${RSTUDIO_PKG}
RUN wget -q https://download3.rstudio.org/ubuntu-14.04/x86_64/${SHINY_PKG}
RUN dpkg -i ${RSTUDIO_PKG}
RUN dpkg -i ${SHINY_PKG}
RUN rm ${RSTUDIO_PKG} ${SHINY_PKG}

RUN chmod 555 /etc/profile.d/set-terminal-prompt.sh
RUN chmod 555 /usr/local/bin/enable-instructor-tools.sh
RUN chmod 555 /usr/local/bin/set-user-start-notebook.sh
USER $NB_UID

RUN pip install git+https://github.com/jupyterhub/jupyter-rsession-proxy
