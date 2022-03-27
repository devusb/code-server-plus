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
    gnupg \
    iputils-ping \
    dnsutils
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y \
    docker-ce-cli kubectl
RUN rm -rf /var/lib/apt/lists/*
RUN curl -s https://fluxcd.io/install.sh | bash
RUN python -m pip install ansible
ENTRYPOINT ["/usr/bin/entrypoint_docker.sh","--bind-addr","0.0.0.0:8080","."]
