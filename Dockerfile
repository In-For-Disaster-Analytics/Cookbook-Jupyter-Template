FROM jupyter/datascience-notebook:ubuntu-22.04

# The user must be swtiched to root in order to install and update packages with apt-get.
# See https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile for info.
LABEL maintainer="TACC-ACI-WMA <wma_prtl@tacc.utexas.edu>"

USER root

RUN apt-get update && apt-get install -y \
    ssh \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /tapis/run.sh

RUN chmod +x /tapis/run.sh

# The user is switched back to the one from set in the base image.
USER 1000
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


RUN pip install --no-cache-dir -U jupyter && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


ENTRYPOINT [ "/tapis/run.sh" ]