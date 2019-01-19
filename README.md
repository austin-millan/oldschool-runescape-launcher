# oldschool-runescape-launcher

This Dockerfile can be used to run the OldSchool RuneScape (OSRS) client in a docker container.

Using the snipped borrowed from [here](https://gist.github.com/udkyo/c20935c7577c71d634f0090ef6fa8393#file-dockerfile), 
the container uses X11 port forwarding over SSH. 

## Requirements

- Docker
- An ssh keypair (ideally in `~/.ssh/id_rsa.pub`)

## Usage

(Usage is set to change depending on updates to the `run.sh` script. I'll update this to
make usage more automatic, letting the user not worry about specific port usage).

To build and run the container, execute the supplied script `./run.sh`.

This will run the container and publish it to a random port on your host computer.


```
$ docker port osrs 22
0.0.0.0:PORT_NUMBER_HERE # this is the output of the previous command
$ ssh -X root@0.0.0.0 -p PORT_NUMBER_HERE
$ oldschool
```

PORT_NUMBER_HERE is the random port the container is listening on for ssh connections, which should be different each time you execute `run.sh`.

## Current Issues

- OSRS client
    - No sound
- `run.sh`
    - automatically `ssh` into the container on success without user input
- RuneMate
    - Currently RuneMate is not able to fully detect the OSRS client when it's running in a container. While it may detect the game frames, it isn't able to access the JVM.
