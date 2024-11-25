# Dockerfile

FROM jenkins/jenkins:jdk17

USER root

# Instala as dependências necessárias
RUN apt-get update -y && apt-get install -y \
    bash \
    curl \
    wget \
    jq \
    git \
    make \
    gcc \
    libffi-dev \
    musl-dev \
    python3 \
    python3-dev \
    python3-venv \
    && apt-get clean

# Cria um ambiente virtual
RUN python3 -m venv /opt/venv

# Ativa o ambiente virtual e instala pacotes Python
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install awscli boto3

RUN mkdir -p /opt/sonar/ \
    && wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.2.1.4610.zip -O /opt/sonar/sonar-scanner.zip \
    && unzip /opt/sonar/sonar-scanner.zip -d /opt/sonar \
    && mv /opt/sonar/sonar-scanner-6.2.1.4610/* /opt/sonar \
    && rmdir /opt/sonar/sonar-scanner-6.2.1.4610/ \
    && rm /opt/sonar/sonar-scanner.zip \
    && chmod +x /opt/sonar/bin/sonar-scanner

# Adiciona o ambiente virtual ao PATH
ENV PATH="/opt/venv/bin:/opt/sonar/bin:$PATH"

# Instala o kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.21.2/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin

# Instala o ArgoCD
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
    && install -m 555 argocd-linux-amd64 /usr/local/bin/argocd \
    && rm argocd-linux-amd64

# Instala o Docker
RUN curl -fsSL https://get.docker.com | sh