FROM jenkins

# Setup docker
USER root

#COPY ./sources.list /etc/apt/sources.list
#RUN apt-get clean
#RUN mv /etc/apt/trusted.gpg.d/ /etc/apt/trusted.gpg.d.backup
#RUN mkdir /etc/apt/trusted.gpg.d
#RUN chmod 755 /etc/apt/trusted.gpg.d
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8B48AD6246925553
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010
RUN echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib\ndeb http://mirrors.163.com/debian/ jessie-updates main non-free contrib\ndeb http://mirrors.163.com/debian/ jessie-backports main non-free contrib\ndeb-src http://mirrors.163.com/debian/ jessie main non-free contrib\ndeb-src http://mirrors.163.com/debian/ jessie-updates main non-free contrib\ndeb-src http://mirrors.163.com/debian/ jessie-backports main non-free contrib\ndeb http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib\ndeb-src http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib" | tee /etc/apt/sources.list

RUN apt-get update && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
    
# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com | sh
RUN gpasswd -a jenkins docker

# Install docker compose
RUN curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Restore user
USER jenkins

# Install plugins
COPY ./plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
#RUN /usr/local/bin/install-plugins.sh /usr/share/jenkins/ref/plugins.txt

# Import jenkins files
COPY ./jenkins_home /var/jenkins_home

# Declare environment variables
ENV DOCKER_HOST=unix:///var/run/docker.sock
