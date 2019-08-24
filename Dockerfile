FROM ubuntu:bionic
COPY sources.list /etc/apt/sources.list
RUN apt update && apt install -y curl unzip build-essential docker.io locales python3-pip && \
    apt clean

RUN locale-gen en_US.UTF-8
RUN useradd -mG docker sam

USER sam
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
RUN ~/.linuxbrew/bin/brew shellenv >> ~/.profile
RUN pip3 install awscli --upgrade --user
RUN . ~/.profile && brew tap aws/tap && \
    brew install aws-sam-cli

USER root
RUN groupmod -g 1001 docker
USER sam

ENV PATH="/home/sam/.local/bin:/home/sam/.linuxbrew/bin:${PATH}"

EXPOSE 3001

ENTRYPOINT ["sam"]