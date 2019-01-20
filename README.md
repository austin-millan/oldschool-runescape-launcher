# oldschool-runescape-launcher

This Dockerfile can be used to run the OldSchool RuneScape (OSRS) client in a docker container.

This Dockerfile uses a snippet of code borrowed from [here](https://gist.github.com/udkyo/c20935c7577c71d634f0090ef6fa8393#file-dockerfile)
for X11 forwarding.

## Requirements

- Docker
- An ssh keypair (ideally in `~/.ssh/id_rsa.pub` on linux distros, or /c/Users/YOUR_USERNAME/.ssh/id_rsa.pub on Windows).

## Usage

To build and run the container, execute the supplied script `./run.sh`. 

This will run the container and publish it to a random port on the host computer, and then lastly will  begin the SSH connection.
Something to note, the command avoids host authenticity checking to make the connection require
little interaction.

```
$ ./run.sh
$ oldschool
```

## Current Issues

- OSRS client
    - No sound
