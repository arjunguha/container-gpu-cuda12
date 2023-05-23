FROM docker.io/nvidia/cuda:12.0.0-cudnn8-devel-ubuntu22.04
RUN apt-get update -q --fix-missing
ENV TZ=America/New_York
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -yq build-essential python3-pip python3.10-venv git tmux vim curl git-lfs
WORKDIR /root
RUN python3 -m venv venv
RUN echo . /root/venv/bin/activate >> /root/.bashrc
RUN . /root/venv/bin/activate && pip3 install --upgrade pip
RUN . /root/venv/bin/activate && pip3 install lit # Needed to build torch for some reason
RUN . /root/venv/bin/activate && pip3 install torch --index-url https://download.pytorch.org/whl/cu118
RUN . /root/venv/bin/activate && pip3 install datasets jupyterlab ipywidgets accelerate wandb transformers
RUN git clone https://github.com/TimDettmers/bitsandbytes.git
WORKDIR /root/bitsandbytes
RUN git checkout 0.38.0
RUN . /root/venv/bin/activate && CUDA_VERSION=120 make cuda12x
RUN . /root/venv/bin/activate && python3 setup.py install
WORKDIR /root
RUN . /root/venv/bin/activate && pip3 install peft
