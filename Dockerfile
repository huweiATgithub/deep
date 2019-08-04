FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# Get some packages
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    # GIT_CLONE="git clone --depth 10" && \
    #=============== removing===
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
    #===============get some packages
    apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
    build-essential \
    software-properties-common \
    wget \
    unzip zip \
    ca-certificates \
    curl \
    git \ 
    && \
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* 

# Install miniconda as well as python and some packages
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y \
    python \
    pip \
    setuptools \
    numpy \
    scipy \
    scikit-learn \
    matplotlib \
    Cython \
    jupyter \
    jupyterlab \
    nb_conda_kernels \
    && \
    # use conda clean --all -f -y https://github.com/jupyter/docker-stacks/issues/861
    /opt/conda/bin/conda clean --all -f -y && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \ 
    # this will activate base for every bash
    echo "conda activate base" >> ~/.bashrc

# Install tensorflow
RUN PIP_INSTALL="pip --no-cache-dir install --upgrade" && \ 
    $PIP_INSTALL tensorflow-gpu==2.0.0-beta1 \
    jupyter-tensorboard \
    pyyaml \
    tqdm \
    && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*
    
# Add tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
ENTRYPOINT ["/bin/tini", "--"]


RUN mkdir /data
VOLUME /data
EXPOSE 8888 6006
CMD ["jupyter", "lab", "--ip=0.0.0.0, "--no-browser", "--port=8888", "--allow-root", "--notebook-dir=/data", "--NotebookApp.password=sha1:a58051cdbd5c:8ee35109f0076445b37be17d926e56bee5910bea"]

