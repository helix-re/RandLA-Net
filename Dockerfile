FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ENV PATH /opt/conda/bin:$PATH

RUN apt-get update && apt-get install -y \
    wget \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Download and install miniconda:
RUN wget --quiet \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate randlanet" >> ~/.bashrc

WORKDIR /RandLA-Net/

# Create the environment:
COPY helper_requirements.txt .
RUN conda create -n randlanet python=3.5

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "randlanet", "/bin/bash", "-c"]

# Install requirements:
RUN pip install tensorflow-gpu==1.11 \
    && pip install -r helper_requirements.txt

# Copy repository and compile:
COPY . /RandLA-Net/
RUN /bin/sh compile_op.sh

# Create data directory:
RUN mkdir /data \
    && mkdir /data/S3DIS
