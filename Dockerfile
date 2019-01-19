FROM ubuntu:18.04
LABEL version "0.2"
LABEL description "Runs your favorite MMORPG (OldSchool RuneScape) in a Docker container!"

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Your public ssh key 
ARG SSH_KEY
RUN mkdir -p /root/.ssh
RUN echo "${SSH_KEY}" >> /root/.ssh/authorized_keys

# Dependencies for installation
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    wget \
    libcurl4 \
    libcurl4-openssl-dev \
    xserver-xorg-video-intel \
    packagekit-gtk3-module \
    libcanberra-gtk-module \
    alsa-utils \
    libasound2-plugins \
    libcanberra-pulse \
    gvfs \
    libpcre3 \
    p7zip-full \
    p7zip-rar

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# OSRS
RUN mkdir -p ~/'runescape/oldschool' '/tmp/oldschool' && \ 
    wget -O '/tmp/oldschool/OldSchool.msi' 'http://www.runescape.com/downloads/oldschool.msi' && \
    7z e -o'/tmp/oldschool/OldSchool-msi' '/tmp/oldschool/OldSchool.msi' && \  
    7z e -o'/tmp/oldschool/rslauncher-cab' '/tmp/oldschool/OldSchool-msi/rslauncher.cab' && \
    cp '/tmp/oldschool/rslauncher-cab/JagexAppletViewerJarFile'* ~/'runescape/oldschool/jagexappletviewer.jar' && \ 
    wget -O ~/'runescape/oldschool/jagexappletviewer.png' 'https://lh3.googleusercontent.com/WLvp10q8TwtyVgMsYL7gW0c7NVG5vnFcRNS7oQtTnSyWbM9kgo_MS8QZa3bsylNgZDba' && \
    rm -Rf '/tmp/oldschool' && sync

# Bash alias & function
RUN echo "oldschool() { \n\
    cd ~/runescape/oldschool && java -Duser.home='.' -Djava.class.path='jagexappletviewer.jar' -Dcom.jagex.config='http://oldschool.runescape.com/jav_config.ws' 'jagexappletviewer' 'oldschool' \n\ 
} \n\  
export -f oldschool \n\ 
alias oldschool=\"cd ~/runescape/oldschool && java -Duser.home='.' -Djava.class.path='jagexappletviewer.jar' -Dcom.jagex.config='http://oldschool.runescape.com/jav_config.ws' 'jagexappletviewer' 'oldschool'\"" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# X Server
RUN apt-get update \
    && apt-get install -y firefox \
                      openssh-server \
                      xauth \
    && mkdir /var/run/sshd \
    && chmod 700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"] 
