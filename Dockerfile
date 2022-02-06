FROM codercom/code-server:latest
USER root
RUN groupmod -g 1101 coder
RUN addgroup --system --gid 1000 docker
RUN usermod -aG docker coder
COPY entrypoint_docker.sh /usr/bin/entrypoint_docker.sh
RUN chmod +x /usr/bin/entrypoint_docker.sh
RUN apt-get update && apt-get install -y \
    python-is-python3 \
    python3-pip \
    ca-certificates \
    curl \
    gnupg
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y \
    docker-ce-cli
RUN rm -rf /var/lib/apt/lists/*
RUN python -m pip install ansible
ENTRYPOINT ["/usr/bin/entrypoint_docker.sh","--bind-addr","0.0.0.0:8080","."]
