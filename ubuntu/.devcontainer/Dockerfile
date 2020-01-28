FROM ubuntu:latest

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt update \
    && apt install -y --no-install-recommends apt-utils dialog 2>&1 \
    && apt install -y git openssh-client iproute2 procps ssh zsh sudo gnupg2 \
    && apt install -y apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common lsb-release \
    #
    # Clean up
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog
