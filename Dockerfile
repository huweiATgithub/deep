FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04


RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \
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
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* 

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
    nb_conda_kernels \
    && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
RUN PIP_INSTALL tensorflow-gpu==2.0.0-beta1

