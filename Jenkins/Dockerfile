FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    python3-pip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    docker.io \
    ansible

# install terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
 > /etc/apt/sources.list.d/hashicorp.list \
 && apt-get update \
 && apt-get install -y terraform

# install azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

USER jenkins