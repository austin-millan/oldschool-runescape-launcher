# oldschool-runescape-launcher

This Dockerfile can be used to run the OldSchool RuneScape (OSRS) client in a docker container.

This Dockerfile uses a snippet of code borrowed from [here](https://gist.github.com/udkyo/c20935c7577c71d634f0090ef6fa8393#file-dockerfile)
for X11 forwarding.

## Requirements

- Docker

## Build

### Option 1: Pull From Docker Registry

```bash
docker pull aamillan/oldschool-runescape-launcher
```

### Option 2: Build it Yourself

```bash
git clone https://github.com/austin-millan/oldschool-runescape-launcher.git && cd oldschool-runescape-launcher
docker build -t oldschool-runescape-launcher:latest .
```

## Run

To run a container, execute the supplied script `./run.sh`, or copy-paste the following command:

```bash
docker run -ti \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       oldschool-runescape-launcher:latest \
       oldschool

```
