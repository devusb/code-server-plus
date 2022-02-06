FROM codercom/code-server:latest
USER root
RUN apt-get update && apt-get install -y \
    python-is-python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*
RUN sudo python -m pip install ansible