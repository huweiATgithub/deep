FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

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
    screen \
    && \
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* 
    
ARG CONDA="/opt/conda/bin/conda"
ARG PY_VERSION=3.7
# Install miniconda as well as python and some packages
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    $CONDA install -y \
    python=$PY_VERSION \
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
    $CONDA clean --all -f -y && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \ 
    # this will activate base for every bash
    echo "conda activate base" >> ~/.bashrc

# Tensorflow 1.14
ARG TF1_VERSION=1.14
ARG NUMPY_TF1_VERSION=1.16
RUN $CONDA create -n tf1 -y --quiet \ 
    pip python=$PY_VERSION tensorflow-gpu=$TF1_VERSION cudatoolkit=10.0 numpy=$NUMPY_TF1_VERSION ipykernel && \
    $CONDA clean --all -f -y
# Tensorflow 2.1
ARG TF2_VERSION=2.1
RUN /bin/bash -c "$CONDA create -n tf2 -y --quiet pip python=$PY_VERSION ipykernel && \ 
    $CONDA activate tf2 && pip --no-cache-dir install --upgrade tensorflow==$TF2_VERSION && \
    $CONDA clean --all -f -y"
# PyTorch
RUN $CONDA create -n torch -y --quiet pip python=$PY_VERSION ipykernel && \
    $CONDA install -n torch -y pytorch torchvision -c pytorch && \
    $CONDA clean --all -f -y

VOLUME /data
EXPOSE 8888 6006

# Add tini
ENV TINI_VERSION v0.18.0
ENV SHELL /bin/bash
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
ENTRYPOINT ["/bin/tini", "--", "jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--port=8888", "--allow-root", "--notebook-dir=/data"]


# CMD ["jupyter", "lab", "--ip=0.0.0.0, "--no-browser", "--port=8888", "--allow-root", "--notebook-dir=/data", "--NotebookApp.password=sha1:379d431d4559:b3171db6ac420a5558b31facb381b37f30a96a86"]
