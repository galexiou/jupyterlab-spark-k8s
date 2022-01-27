# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=galexiou
ARG BASE_CONTAINER=$OWNER/pyspark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Giorgos Alexiou <galexiou@gmail.com>"

USER root

# RSpark config
ENV R_LIBS_USER "${SPARK_HOME}/R/lib"
RUN fix-permissions "${R_LIBS_USER}"

# R pre-requisites
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-dejavu \
    gfortran \
    curl \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV SPARK_DIST_CLASSPATH "/opt/hadoop/etc/hadoop:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/yarn:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*"
# RUN echo 'export SPARK_DIST_CLASSPATH=$(hadoop classpath)' >> "/usr/local/bin/before-notebook.d/spark-config.sh"


USER ${NB_UID}

#almond kernel
# ENV PATH "$PATH:/opt/conda/.local/share/coursier/bin"

RUN cd /opt/conda
RUN mkdir coursier
RUN mkdir coursier/cache

ENV COURSIER_CACHE "/opt/conda/coursier/cache"

RUN curl -fLo cs https://git.io/coursier-cli-"$(uname | tr LD ld)" && \
  chmod +x cs && \
  # ./cs install cs && \
  # rm cs && \
  # cs update cs && \
  ./cs launch --fork almond:0.10.9 --scala 2.12 -- --jupyter-path /opt/conda/share/jupyter/kernels --display-name "Almond-kernel (2.12)"  --install
  # rm -f cs

# R packages including IRKernel which gets installed globally.
RUN mamba install --quiet --yes \
    'r-base' \
    'r-ggplot2' \
    'r-irkernel' \
    'r-rcurl' \
    'r-sparklyr' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Spylon-kernel
RUN mamba install --quiet --yes 'spylon-kernel' && \
    mamba clean --all -f -y && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf "/home/${NB_USER}/.local" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
# ENTRYPOINT ["/usr/local/spark/kubernetes/dockerfiles/spark/entrypoint.sh"]
