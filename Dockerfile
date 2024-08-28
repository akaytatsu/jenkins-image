# Dockerfile

# Use a imagem base do Alpine Linux com Python 3 instalado
FROM jenkins/jenkins:lts

USER root

# Instala as dependências necessárias
RUN apt-get update -y && apt-get install -y \
    bash \
    curl \
    jq \
    git \
    make \
    gcc \
    libffi-dev \
    musl-dev \
    python3 \
    python3-dev \
    python3-pip \
    && pip3 install --upgrade pip

# Instala o AWS CLI e o boto3
RUN pip3 install awscli boto3

# Instala o kubectl
# RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
RUN curl -LO "https://dl.k8s.io/release/v1.21.2/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin

RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
    && install -m 555 argocd-linux-amd64 /usr/local/bin/argocd \
    && rm argocd-linux-amd64

RUN curl -fsSL https://get.docker.com | sh
