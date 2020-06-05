FROM ubuntu:latest

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils dialog 2>&1 && \
    apt-get install -y sudo git openssh-client iproute2 procps ssh zsh build-essential gnupg2 gawk language-pack-en && \
    apt-get install -y apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common lsb-release && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Add "Set disable_coredump false" to /etc/sudo.conf
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# Setup
RUN git clone https://github.com/lyrise/dotfiles.git && \
    (cd dotfiles && sh install_ubuntu.sh) && \
    rm -rf ./dotfiles

# Switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog
