FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ENV PATH /opt/conda/bin:$PATH

RUN apt-get update && apt-get install -y \
    wget \
    libgl1-mesa-glx \
    git \
    && rm -rf /var/lib/apt/lists/*

# Download and install miniconda:
RUN wget --quiet \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate randlanet" >> ~/.bashrc

# Set the working directory:
WORKDIR /RandLA-Net

# Create the environment:
RUN conda create -n randlanet python=3.5

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "randlanet", "/bin/bash", "-c"]

# Install requirements:
RUN pip install tensorflow-gpu==1.11

# Copy the repository:
COPY . /RandLA-Net