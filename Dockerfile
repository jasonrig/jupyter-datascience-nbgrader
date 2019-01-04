ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jason Rigby <hello@jasonrig.by>"

USER $NB_UID

RUN conda install --quiet --yes -c conda-forge nbgrader
RUN conda install --quiet --yes \
    'r-testthat=2.0*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader
RUN jupyter nbextension disable --sys-prefix create_assignment/main
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader

COPY enable-instructor-tools.sh /usr/local/bin/
COPY set-user-start-notebook.sh /usr/local/bin/

USER root

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		libapparmor1 \
		libedit2 \
		lsb-release \
		psmisc \
		libssl1.0.0
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV RSTUDIO_PKG=rstudio-server-1.1.463-amd64.deb
RUN wget -q https://download2.rstudio.org/${RSTUDIO_PKG}
RUN dpkg -i ${RSTUDIO_PKG}
RUN rm ${RSTUDIO_PKG}

RUN chmod 555 /usr/local/bin/enable-instructor-tools.sh
RUN chmod 555 /usr/local/bin/set-user-start-notebook.sh
USER $NB_UID

RUN pip install git+https://github.com/jupyterhub/jupyter-rsession-proxy
ENV PATH="${PATH}:/usr/lib/rstudio-server/bin"
ENV LD_LIBRARY_PATH="/usr/lib/R/lib:/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server:/opt/conda/lib/R/lib"
