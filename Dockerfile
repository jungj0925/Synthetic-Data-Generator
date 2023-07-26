FROM nvidia/cuda:11.3.0-cudnn8-runtime-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    ccache \
    curl \
    redis-server \
    wget

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    pkg-config \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    libglvnd-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    mesa-utils \
    ninja-build \
    g++ \
    libxml2 \
    gnupg \
    software-properties-common \
    cmake 

ENV LD_LIBRARY_PATH /usr/lib64:$LD_LIBRARY_PATH

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 6379

COPY startup.sh /.
COPY Next3D /.
COPY nvdiffrast /nvdiffrast/.
COPY environment.yml /.

ENV LANG C.UTF-8
RUN curl -o /tmp/miniconda.sh -sSL http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -bfp /usr/local && \
    rm /tmp/miniconda.sh
RUN conda update -y conda

RUN conda env create -f environment.yml
RUN echo "source activate env" >> ~/.bashrc

SHELL ["conda", "run", "-n", "env", "/bin/bash", "-c"]

RUN conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch

RUN conda install -c fvcore -c iopath -c conda-forge fvcore iopath

RUN conda install pytorch3d -c pytorch3d

RUN conda install -c conda-forge cudatoolkit-dev -y

RUN pip install ninja imageio imageio-ffmpeg jittor==1.3.6.4

RUN cd /nvdiffrast && pip install .

CMD ["redis-server", "--protected-mode no"]
