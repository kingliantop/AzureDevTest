# Environment Setup #

The purpose of this project is to demonstrate how you might configure a
development, test and deployment scenario on your workstation and on Azure 
using Docker. You will need setup one or more Docker hosts and thus you'll
need to setup some base tooling.

## Windows Pre-Requisites ##

Windows users should install Git for Windows from http://msysgit.github.io/.

This will provide both Git and a Bash shell. We will use the Bash shell as a
convenience since the scripts we have built are Bash scripts.

You will also need to ensure that either Hyper-V is turned on or you
have installed Virtual Box (version 4.3.x from
https://www.virtualbox.org/wiki/Download_Old_Builds_4_3)

## Linux Pre-Requisites ##

You will need to install virtualbox 4.3.x from
https://www.virtualbox.org/wiki/Download_Old_Builds_4_3

## Configure.sh ##

The helper scripts provided are configured in scripts/config.sh. You will
need to create this file. We provide a template file to get you started
with good defaults where we can. Start by copying the template:

    $ cp script/config.tmpl script/config.sh
    
Now edit this file, being sure to change (at least) the
STAGING_MACHINE_NAME which must be world unique.

## Install Docker, Docker Machine and Docker Compose

We will use Docker Machine to create our Docker Hosts. You will then
use the Docker command to manage containers on those hosts. The
sections below briefly describe how to install these tools, see
http://docs.docker.com/machine/ for more information.

### Windows Docker Install ###

On Windows open a Bash shell (search for "Unix Bash" after installing Git
for Windows):

    curl -L https://get.docker.com/builds/Windows/x86_64/docker-latest.exe > /bin/docker
    curl -L -k https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_windows-amd64.exe > /bin/docker-machine

NOTE: You might want to check whether v0.3.1 is the latest version by visiting the [Docker Machine releases page](https://github.com/docker/machine/releases)

### Linux Docker Install ###

In a shell type:

    sudo wget https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_linux-amd64 -O /usr/local/bin/docker-machine
    sudo chmod +x /usr/local/bin/docker-machine
    sudo wget https://get.docker.com/builds/Linux/x86_64/docker-latest -O /usr/local/bin/docker
    sudo chmod +x /usr/local/bin/docker
    curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose


If you


NOTE: You might want to check whether v0.3.1 is the latest version of Machine by visiting the [Docker Machine releases page](https://github.com/docker/machine/releases). You should also check that 1.4.0 is the latest version of Docker Compose by visiting the [Docker Compose release page](https://github.com/docker/compose/releases).


### Verify Install ##

You should now be able to run the following commands and see the
appropriate version numbers.

    docker --version
    docker-machine --version
    docker-compose --version

### Configure Docker Machine for Azure##

If you want to use Azure as a cloud provider you need to configure
Docker Machine to use your subscription. If you don't already have an
Azure subscription you can get a free trial at
http://azure.microsoft.com/en-us/pricing/free-trial/

Once you have an active subscription run the following commands in a shell:

    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
    openssl pkcs12 -export -out mycert.pfx -in mycert.pem -name "My Certificate"
    openssl x509 -inform pem -in mycert.pem -outform der -out mycert.cer

Now you need to go to the Azure portal (https://manage.windowsazure.com). In the "Settings" 
section select "Management Certificates" and upload mycert.cer.

Grab your subscription ID from the portal and record this in your
script/config.sh file as the value for SUBSCRIPTION_ID.

## Create Docker Hosts ##

We will set up Docker host machines as defined in the
/script/config.sh file. This includes:

  1. dev host machine (default type: Hyper-V, default name: dev)
  2. staging host machine (default type: Hyper-V, default name: dev)

Remember, the name of the staging host in script/config.sh must be
world unique as it will double as the dns name.

Now you can look a tthe machine status with:

    docker-machine ls

### Open Ports on cloud hosted Docker Machines ###

It is necessary to open the appropriate ports on your Docker hosts to allow 
access to the applications:

    - port 80:80for the webapp on the staging machine
    - [optional] port 8080:8080 for the REST API on the staging machine

## Running the Application ##

Now you are all set up, to build and run the application on the dev
server run:

  script/dev.sh

The first time you run this command Docker will pull down the necessry
container layers and update the packages in the container, this can
take a little while. Once you have the layers locally subsequent
builds will be much faster.

Once everything is complete you can view the results with:

    http://DEV_MACHINE_IP:$DEV_WEBAPP_PORT
    http://DEV_MACHINE_IP:8080/JerseyHelloWorld/rest/helloworld

Once enough time has elapsed for the load tests to complete you will
also be able to see the results of these tests by running the command:

    eval "$(docker-machine env $DEV_MACHINE_NAME)"
    docker logs load

To build and run on the staging server run:

    script/stage.sh

Once everything is complete you can view the results with:

    http://127.0.0.1:8888
    http://127.0.0.1:8080/JerseyHelloWorld/rest/helloworld

Once enough time has elapsed for the load tests to complete you will
also be able to see the results of these tests by running the command:

    eval "$(docker-machine env $DEV_MACHINE_NAME)"
    docker logs load

