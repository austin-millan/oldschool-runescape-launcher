# osrs container

This Dockerfile can be used to run the OldSchool RuneScape (OSRS) client in a docker container.

Using the snipped borrowed from [here](https://gist.github.com/udkyo/c20935c7577c71d634f0090ef6fa8393#file-dockerfile), 
the container uses X11 port forwarding with SSH. 

## Requirements

You'll need to append to your host's `~/.ssh/config` the following:

```
Host abc
     Hostname HOST_NAME_HERE
     Port 2150
     user root
     ForwardX11 yes
     ForwardX11Trusted yes
```

You'll also need to edit the Dockerfile to include a public key from your host, under CHANGEME.

## Usage

To build and run the container, execute the supplied script `./run.sh`, or, run the sequence of commands: 

```
$ docker build -t osrs .
$ docker run -it --rm -p 2150:22 osrs
$ ssh -X -v root@osrs
$ oldschool_func
$ P $ R $ O $ F $ I $ T
```

## Current Issues

- No sound
- Dockerfile is messy
- RuneMate not setup yet
- No proxifier
- etc.
