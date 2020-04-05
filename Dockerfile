FROM ubuntu:18.04
LABEL version "0.2"
LABEL description "Runs your favorite MMORPG (OldSchool RuneScape) in a Docker container!"

ENV DEBIAN_FRONTEND noninteractive
# Install OpenJDK 8
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;
RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

# Set JAVA_HOME ENV
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Dependencies for OSRS Installation
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    wget \
    libcurl4 \
    libcurl4-openssl-dev \
    packagekit-gtk3-module \
    libcanberra-gtk-module \
    alsa-utils \
    libasound2-plugins \
    libcanberra-pulse \
    gvfs \
    libpcre3 \
    p7zip-full \
    p7zip-rar

# Download OSRS
RUN mkdir -p ~/'runescape/oldschool' '/tmp/oldschool' && \ 
    wget -O '/tmp/oldschool/OldSchool.msi' 'http://www.runescape.com/downloads/oldschool.msi' && \
    7z e -o'/tmp/oldschool/OldSchool-msi' '/tmp/oldschool/OldSchool.msi' && \  
    7z e -o'/tmp/oldschool/rslauncher-cab' '/tmp/oldschool/OldSchool-msi/rslauncher.cab' && \
    cp '/tmp/oldschool/rslauncher-cab/JagexAppletViewerJarFile'* ~/'runescape/oldschool/jagexappletviewer.jar' && \ 
    wget -O ~/'runescape/oldschool/jagexappletviewer.png' 'https://lh3.googleusercontent.com/WLvp10q8TwtyVgMsYL7gW0c7NVG5vnFcRNS7oQtTnSyWbM9kgo_MS8QZa3bsylNgZDba' && \
    rm -Rf '/tmp/oldschool' && sync

# Bash alias & function, oldschool run script. This provides numerous ways to launch OSRS.
RUN echo "oldschool() { \n\
    cd ~/runescape/oldschool && java -Duser.home='.' -Djava.class.path='jagexappletviewer.jar' -Dcom.jagex.config='http://oldschool.runescape.com/jav_config.ws' 'jagexappletviewer' 'oldschool' \n\ 
} \n\  
export -f oldschool \n\ 
alias oldschool=\"cd ~/runescape/oldschool && java -Duser.home='.' -Djava.class.path='jagexappletviewer.jar' -Dcom.jagex.config='http://oldschool.runescape.com/jav_config.ws' 'jagexappletviewer' 'oldschool'\"" >> ~/.bashrc
RUN echo "#!/bin/bash\ncd ~/runescape/oldschool && java -Duser.home='.' -Djava.class.path='jagexappletviewer.jar' -Dcom.jagex.config='http://oldschool.runescape.com/jav_config.ws' 'jagexappletviewer' 'oldschool'" >> /usr/bin/oldschool
RUN chmod +x /usr/bin/oldschool
RUN /bin/bash -c "source ~/.bashrc"

RUN apt-get install -y vim

CMD ["/bin/bash", "oldschool"]
