# Getting Started with Docker and Hyper-V #

## Overview ##

We will setup a Docker Host on your Windows machine and deploy two
containers to it. The first container will have a Java application
which provides a very simple REST API. The second container will have
a simple web application which displays information from both the
web applicaton and the Java REST API.

While this document focuses on Windows these instructions should be
almost identical for other operating systems. Where there are
differences we will highlight them in the text.

The application we will build is nothing more than a simple "hello
world" using a web application connecting to a Java REST API.

## Why? ##

Docker containers can be deployed anywhere. This allows us to move the
same continers from development, to staging and on into
production. This first activity will focus on creating a development
environment. Later we will reuse the Docker containers to deploy your
applications to a staging server on Microsoft Azure where you will be
able to run tests against the latest versions. Finally, we will deploy
the tested containers to a produciton server.

## What You Will Learn ##

    * How to install Docker and Docker Machine on Windows
    * How to use Docker Machine to create a Docker Host on Hyper-v
	* How to build an deploy a containerized two tier application

## Tools You will Use ##

    * Docker
    * Docker Machine
	* Git for Windows
	* Bash

## The Steps ##

### Install Git for Windows ###

Windows users should install Git for Windows from http://msysgit.github.io/.

This will provide both Git and a Bash shell. We will be building some
convenience scripts to make the commands we run simpler. Since Docker
currently recommends using a Bash shell we will also write these
scripts in Bash. This shell also brings an SSH client which is used by
Docker.

We could use PowerShell for this but we have not tested this approach
at this time.

Another advantage of using a Bash shell is that the scripts we create
should be usable on Linux and MAC OSX.

### Install Docker and Docker Machine on Windows ###

We will use Docker Machine to create our Docker Hosts. 

On Windows open a Bash shell with administrative permissions by
hitting Windows and tpying "Unix Bash", right click on "Unix bash" and
select "Run as Adminstrator" (note, these commands don't require admin
priviledges but later we will create a virtual machine which does
require elevated permissions. If you prefer not to run downloaded
scripts in an elevated shell then you can always open a separate shell
later.)

    curl -L https://get.docker.com/builds/Windows/x86_64/docker-latest.exe > /bin/docker
    curl -L https://github.com/docker/machine/releases/download/v0.2.0/docker-machine_windows-amd64.exe > /bin/docker-machine

See the Docker website for instructions on installing Docker and Docker 
Machine on other platforms see: http://docs.docker.com/machine/

Upon completion you should be able to run 'docker-machine --version'
and 'docker --version'.

### Ensure Hyper-V is enabled ###

On your Windows client ensure Hyper-V is enabled by hitting the
Windows key and typing "windows features". You should be presented
with an option to "Turn Windows Features on or off". Select this
option and in the resulting dialog ensure "Hyper-V" is checked.

If you can use another virtualization technology, such as VirtualBox
if you prefer (indeed if you are on an OS other than Windows you will
have to use another).

### Ensure you have a suitable vswitch enabled ###

Docker Machine will needs a network connection, so you must ensure
that a vswitch is avialable.

See
http://www.techrepublic.com/blog/windows-and-office/create-a-virtual-switch-in-windows-8-client-hyper-v/
for guidance.

### Create a Docker Host using Hyper-V ###

Docker Machine is used to create Docker Hosts. A Docker Host is a
virtual machines on which you can create and manage Docker
containers. To create a host run the following command in an elevated
Bash shell on your Windows client (replacing MACHINE_NAME with the
name for this Docker Host, e.g. "dev"):

    docker-machine create -d hyper-v MACHINE_NAME

Your Docker Host should be created after a few minutes. If, for any
reason, it fails you need to ensure you remove any remnants of the
failed operation. To do this run the following command in your Windows
Bash shell:

    docker-machine rm -f MACHINE_NAME

To diagnose problems add the "--debug" switch to the create
command. The most common problem at this stage is to run the create
commadn in a shell that does not have admin permissions.

This command will download the Virtual Machine image (called
Boot2Docker), start it and configure it to work over SSH from your
client. The downloaded image already has the Docker daemon install on
it for you.

### Get the IP Number of Your Docker Host ###

You can verify your VM is running by running the follwoing command in
your Windows Bash shell:

    docker-machine ssh

This will connect you to the Boot2Docker VM via SSH. While you are
here you should retrieve the IP number of the VM by running the
following command:

    ifconfig eth0

Take a note of the IP number as you will need it later. Once you have
written it down leave the VM by typing "exit" and hit return.

### Tell Docker to Use Your Docker Host ###

In this first use case we will only be working with a single Docker
Machine. However, in reality we will often work with multiple Docker
Machines. For this reason we need to tell the Docker command which
host to use. Fortunately Docker Machine makes this easy for us, simply
run the following command in your Windows Bash shell.

    eval "$(docker-machine env [MACHINE_NAME])"

On this case MACHINE_NAME is optional since we only have a single
machine so we know we will always be using the correct
configuration. However, in the next use case we will be introducing a
second machine and then a third.

### Clone the Application from GitHub ###

Since we used Git for Windows to bring us a Bash shell we also have
Git installed. We'll now use that to clone the application code from
GitHub. In your Bash shell run the following command:

    cd your_preferred_parent_directory
    git clone https://github.com/rgardler/AzureDevTestDeploy.git

Once completed you will have the full source of the application we
will deploy, along with a few helper scripts that encapsulate
repetitive tasks. In this document we will not use the helper scripts,
instead we will focus on learning the commands individually. Later we
can take shortcuts and use the scripts.

### Build the Java REST API Container ###

We have two containers in our simple application. The first we will
deploy is the Java REST API. To do this run the following commans in
your Windows Bash shell.

    cd java
    docker build -t rest:latest .

This command will build our Java application container and give it a
name of "javaapp" and a tag of "latest". The first time you run it
Docker will download all the necessary "layers" for the Docker
container (in this case the operating system with Apache Tomcat
installed and configured) it will then install a few necessary
software packages and finally it will build and deploy the Java
application.

The first time this is run it will take a few minutes to download all
the necessary bits. However, if you run it again immediately after the
first run it will be almost instant since Docker is smart enough to
only repeat steps that are necessary. If you hav emade not changes to
the application or its environment then there is nothing to rebuild.

### Run the Java REST API Container ###

To run the container on your Docker Host run the following command in
your Windows Bash shell:

    docker run -td -p 5555:8080 --name=dev_rest rest:latest

Almost immediatley your container will start. You can verify this to
yourself by visiting the API at the following URL

    http://IP_NUMBER:5555/JerseyHelloWorld/rest/helloworld 

Be sure to replace "IP_NUMBER" with the IP number of the Docker Host
that you retrieved above in the section "Get the IP Number of Your
Docker Host". Note that the port number we are using here is 5555 as
defined in the "-p" switch of the command above. It is mapped to port
8080 on the container which is the default port used by Tomcat.

### Build and Run The Web Application Container ###

The process for building and runing the web application container is
the same. Run the following commands in your Windows Bash shell:

    cd ..
    cd asp
	docker build -t web:latest .
	docker run -td -p 8888:8888 --link dev_rest:rest --name=dev_web web:latest

As before the first time you run the build command it will take a few
minutes. Subsequent runs will be much faster.

Note that the "--link dev_rest:rest" links the two containers
together. This allows the application code to know where the rest api
container is located.

Once the container is running you can visit the web frontend at:

    http://[IP_NUMBER]:8888

You should see a simple page which is built from a combination of web
application content and the results of a call to the Java application.

### Lets make a change to our Application Code ###

Now we will edit the application code. In your favourite editor open
www/html/index.php and change the <h1> text to something unique.

We have edited the content of the file but if you revisit the web page
you will not see the changes you made. This is because containers are
intended to be immutable. The Container is using a snapshot of your
application code taken when you ran the build command above. Therefore
to see the changes we need to stop the currently running container,
rebuild it and restart it.

To do this you run the following commands in your Bash shell:

    docker stop dev_web
    docker rm dev_web
	docker build -t web:latest .
	docker run -td -p 80:8888 --link dev_rest:rest --name=dev_web web:latest

Note how the container build is still very fast, even though we have
made some changes to the applicaton. This is because all the
preparation work we did in the earlier build has been cached and
therefore Docker only needs to perform the build steps from where
things have changed, in this case from where we copy the application
code into the container.

Once you have re-run the container you can refresh your browser and
you should see the changed text in the welcome.

### Scripting Repetitive Tasks ###

It is always a good idea to script repetitive tasks. To this end you
can find "dev_web.sh" and "dev_java.sh" scripts in the "script"
directory of the project. These two scripts will perform all of the
steps above for building the web application and Java containers
respectively. They should be run from the root of the project.

There is also a "dev.sh" that will run both of the above scripts and
thus build and deploy both the Java and web applications.

These scripts use some values that are imported from from a
"script/config.sh". In order to create this file copy
"script/config.tmpl" to "script/config.sh" and edit it. The fie should
be self explanatory. For the dev environment all you need to configure
is the DEV_MACHINE_NAME which is the value used in place of
MACHINE_NAME in the above commands.

Try them out now. Remove your edits from the www/index.html file
and then execute the following commands from your Windows bash shell:

    cd ..
    script/dev.sh

Of course using a more powerful configuration managemen tool would be
a good next move, but that is out of scope for this guide.
