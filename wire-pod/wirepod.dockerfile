ARG BUILD_FROM=ubuntu:jammy
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Edit your timezone here:
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install software
RUN apt-get update \
 && apt-get install -y \
    sudo \
    nano \
    git

# Setup Sudoers
RUN adduser --disabled-password --gecos '' wirepod
RUN adduser wirepod sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to created wirepod user
USER wirepod

# Create /wire-pod directory
RUN sudo mkdir /wire-pod
RUN sudo chown -R wirepod:wirepod /wire-pod
RUN cd /wire-pod

# Download wire-pod
RUN git clone https://github.com/kercre123/wire-pod/ wire-pod

# Build wire-pod
WORKDIR /wire-pod
RUN chmod a+x ./setup.sh
RUN chmod a+x ./chipper/start.sh
RUN sudo STT=vosk ./setup.sh

# Start chipper
WORKDIR /wire-pod/chipper
CMD sudo /wire-pod/chipper/start.sh