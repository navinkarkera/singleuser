FROM jupyter/minimal-notebook:latest
ENV JUPYTERHUB_VERSION=1.1.0
ENV JUPYTERLAB_VERSION=2.2.4
ENV JUPYTERNBDIME_VERSION=2.0.0
ENV JUPYTERCLIENT_VERSION=6.1.6
ENV JUPYTERGIT_VERSION=0.20.0
ENV NB_UMASK=022
ENV NB_USER=ftp
ENV NB_UID=21
ENV NB_GID=21
ENV NB_GROUP=21
ENV PYTHONPATH=/home/pylib
ENV TZ Europe/Paris
USER root

RUN mkdir /home/$NB_USER && \
    mkdir /home/$NB_USER/ftp && \
    fix-permissions /home/$NB_USER

RUN python3 -m pip install --no-cache \
    jupyterhub==$JUPYTERHUB_VERSION \
    jupyterlab==$JUPYTERLAB_VERSION  \
    jupyter_client==$JUPYTERCLIENT_VERSION  \
    jupyterlab-git==$JUPYTERGIT_VERSION \
    nbdime==$JUPYTERNBDIME_VERSION  \
    nbformat \
    nbconvert \
    nbresuse \
    ipyparallel \ 
    ipywidgets \
    ipympl \
    jupyter-server-proxy \
    jupyter-launcher-shortcuts \
    naas \
    naas-drivers \
    matplotlib && \
    jupyter labextension install --no-build \
    @elyra/python-editor-extension \
    jupyterlab-launcher-shortcuts \
    @jupyterlab/server-proxy \
    @jupyterlab/toc \
    jupyter-matplotlib \
    @jupyter-widgets/jupyterlab-manager \
    jupyterlab-plotly && \
    jupyter lab build

COPY jupyter_notebook_config.py /etc/jupyter/
COPY naas_logo.jpg /etc/jupyter/naas_logo.jpg

# add system packages
RUN apt-get update && \
    apt-get -y install tzdata tesseract-ocr libtesseract-dev