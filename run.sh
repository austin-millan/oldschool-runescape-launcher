#!/bin/sh

YOUR_KEY_PATH="$HOME/.ssh/id_rsa.pub"

if [ ! -f $YOUR_KEY_PATH ]; then
    echo "Unable to locate ssh key (at $YOUR_KEY_PATH)"
    echo "Please run: 'ssh-keygen -t rsa', or provide the path by editing the run.sh script."
    exit 1
fi

YOUR_KEY="$(cat $YOUR_KEY_PATH)"

docker build --build-arg \
    SSH_KEY="$YOUR_KEY" \
    -t osrs:latest \
    .
docker run -d -P --name osrs osrs