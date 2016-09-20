# Getting Started with Docker and Microsoft Azure #

## Overview ##

This Getting Started guide builds upon the previous guide. Where this
guide focusses on Azure hosted Docker containers, the previous guide
focussed on Hyper-V hosted containers. It is assumed that you have
completed the previous guide before starting this one.

We will setup a Docker Host on an Azure Virtual machine and deploy two
containers to it. The first container will have a Java application
which provides a very simple REST API. The second container will have
a simple web application which displays information from both the
web applicaton and the Java REST API.

While this document focuses on Windows as the client machine and Azure
as the cloud provider these instructions should be almost identical
for other operating systems and clouds. Where there are differences we
will highlight them in the text.

The application we will build is nothing more than a simple two
container "hello world".

## Why? ##

Docker containers can be deployed anywhere. This allows us to move the
same continers from development, to staging and on into
production. The first of these guides focused on creating a
development environment on a local client machine. In this guide we
will use the same application and code to deliver the application to a
staging server hosted on Microsofot Azure. This demonstrates how a
developers environemnt can mirror the staging environment used for
interation and user acceptance testing. Finally, we will deploy the
tested containers to a produciton server.

## What You Will Learn ##

    * How to create an Microsoft Azure subscription (free trial avialable)
    * How to use Docker Machine to create a Docker Host on Microsoft Azure
	* How to build an cloud deploy a containerized two tier application

## Tools You will Use ##

	* Microsoft Azure IaaS
	* Docker
    * Docker Machine
	* Git for Windows
	* Bash

## The Steps ##

### Pre-requisites ###

Complete the Getting Started with Docker and Hyper-V

### Create a Microsoft Azure Subscription ###

If you already have an Azure subscription you can skip forward to the
next step.

If you do not yet have a subscription then you can create a free trial
by visiting http://aka.ms/docker_guide.

### Create Certificates and Register them with Azure ###

Once you have an active azure subscription run the following commands
in a Bash shell:

    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
    openssl pkcs12 -export -out mycert.pfx -in mycert.pem -name "My Certificate"
    openssl x509 -inform pem -in mycert.pem -outform der -out mycert.cer

Now you need to go to the Azure portal
(https://manage.windowsazure.com). Select "Settings" (all the way down
at the bottom on the right) and then "Management Certificates" and
click upload. Browse to your mycert.cer and click the tick.

Now grab your subscription ID from the portal, click "Subscription" on the settings page and copy the appropriate subscription ID.

### Create a Docker Host on Microsoft Azure ###

To create a host on Microsoft Azure run the following command in a
Bash shell on your Windows client (replacing MACHINE_NAME with the
name for this Docker Host, e.g. "dev"):

    docker-machine create -d azure --azure-subscription-id="SUBSCRIPTION_ID" --azure-subscription-cert="mycert.pem" MACHINE_NAME

Be sure to replace SUBSCRIPTION_ID with the ID you retrieved in the
previous section and MACHINE_NAME with your preferred name for this
Docker Machine (e.g. "stage").

This command will create a Virtual Machine on Azure, start it and
configure it to work over SSH from your client.

### Open Ports on the Docker Machine ###

Our application will use port 80 for the web application and port 8080
for the REST API. We will need to open these ports on our Docker
Host. In the Azure management portal find your virtual machine
Endpoints page (Virtual Machines -> MACHINE_NAME -> Endpoints). Add
two new endpoints, one for the web appication (public port 80 to
private port 8888) and one for the REST API (public port 8080 to the
private port 8080).

### Tell Docker to Use Your Docker Staging Host ###

Run the following command in your Windows Bash shell in order to
ensure that Docker will run against your staging server.

    eval "$(docker-machine env [MACHINE_NAME])"

Remember to cange MACHINE_NAME to the correct name, e.g. "stage"

### Build the Container ###

In the previous guide we built and ran the Java REST API container
locally. We used the tag "latest" to indicate that it was the latest
code. Now we will run the container on the staging server. To do this
we want to be sure we can identify which version of the code we are
running. we will therefore give it a version number. Since this is our
first test version we will call it 0.1.0.

Build the container with the following command:

    cd java
    docker build -t rest:0.1.0 .

### Deploy the Java REST API Container ###

To deploy the container on your staging server run the following
command in your Windows Bash shell:

    docker run -td -p 8080:8080 --name=stage_rest rest:0.1.0

Almost immediatley your container will start. You can verify this to
yourself by visiting the API at the following URL

    http://MACHINE_NAME.cloudapp.net:5050/JerseyHelloWorld/rest/helloworld

Be sure to replace "MACHINE_NAME" with the name of your staging
machine, e.g. "stage".

### Build and Run The Web Application Container ###

The process for building and runing the web application container is
the same. Run the following commands in your Bash shell:

    cd ..
    cd asp
	docker build -t web:0.1.0 
	docker run -td -p 80:80 --link stage_rest:rest --name=web web:0.1.0

Once the container is running you can visit the web frontend at:

    http://MACHINE_NAME.cloudapp.net

### Scripting Repetitive Tasks ###

It is always a good idea to script repetitive tasks. To this end you
can find "stage_web.sh" and "stage_java.sh" scripts in the "script"
directory of the project. These two scripts will perform all of the
steps above for building and deploying the web application and Java
containers respectively. They should be run from the root of the
project. There is also a "stage.sh" script that will stage both
applications at the same time.

These scripts use some values that are imported from from a
"script/config.sh" that you created in an earlier guide. You will need
to set the STAGE_MACHINE_NAME, which is the value used in place of
MACHINE_NAME in the above commands. You will also want to set the
WEB_STAGE_VERSION and REST_STAGE_VERSION which will be used to tag the
container builds (e.g. web:WEB_STAGE_VERSION). These values should be
increased each time we stage a new version of the application.

Try them out now execute the following commands from your Windows bash
shell:

    cd ..
    script/stage.sh

Of course using a more powerful configuration managemen tool would be
a good next move, but that is out of scope for this guide.

