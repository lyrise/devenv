#! /bin/bash
# https://gist.github.com/ryujaehun/991f5f1e8c1485dea72646877707f497

# Make tmp directory
mkdir tmp

# Make sure you grab the latest version
wget -q https://github.com/protocolbuffers/protobuf/releases/download/v3.9.2/protoc-3.9.2-linux-x86_64.zip -O tmp/protoc-3.9.2-linux-x86_64.zip

# Unzip
unzip tmp/protoc-3.9.2-linux-x86_64.zip -d tmp/protoc3

# Move protoc to /usr/local/bin/
sudo mv tmp/protoc3/bin/* /usr/local/bin/

# Move protoc3/include to /usr/local/include/
sudo mv tmp/protoc3/include/* /usr/local/include/

# Optional: change owner
sudo chown $USER /usr/local/bin/protoc
sudo chown -R $USER /usr/local/include/google/protobuf

# Delete tmp directory
sudo rm -rf tmp
