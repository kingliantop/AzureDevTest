# Objectives

1. Demonstrate how we can use Jenkins for continuous integration
2. Demonstrate how we can use Jenkings for Continuous Delivey

---

# Setup

  * You will need:
    * A dev machine with:
      * Docker
      * Docker Compose
    * An ACS cluster
      * Until the service enters preview use https://github.com/anhowe/scratch/tree/master/mesos-marathon
    * A CI/CD machine (can be the jumpbox in the ACS cluster)

## Details

Sections below this one describe the setup of these machines in detail.

--

# Dev Machine

This machine is used to show the dev workflow:

  * Run the application locally
  * Make some edits
  * Verify Changes
  * Push to version control

--

# Dev Machine Configuration
  * Docker
  * Docker Compose
  * Open a terminal
    * set to full screen
    * set font to a suitable size for the projector
  * Run the following commands

```
git clone https://github.com/rgardler/linux-config.git
./linux-config/configure.sh
git clone https://github.com/rgardler/AzureDevTestDeploy.git
cd AzureDevTestDeploy
./demo/demo250_automated_deployment/prepare.sh
```
--    

# CI/CD Machine Configuration

We will use the jumpbox as our CI/CD machine as well. On the jumpbox run the following commands:

```
git clone https://github.com/rgardler/linux-config.git
./linux-config/configure.sh
git clone https://github.com/rgardler/AzureDevTestDeploy.git
cd AzureDevTestDeploy/ci
docker-compose up -d
docker exec -it ci_jenkins_1 bash
docker login
# Enter user and password details
exit
```

Open a tab on the Jumpbox browser for htpp://localhost:8081

## Details

NOTE: for CI/CD to work you will need push access to the Docker Hub
organization adtd, raise an issue in GitHub if you need this.

You now have a Jenkins instance running on port 8081 on the Jumpbox

It is configured to detect changes in the source, build the
containers, test them, push them to Docker Hub and to publish to our
Staging cluster.

[OPTIONAL] you could open port 8081 on the VM and have this publicly accessible

--

# Azure Container Service Cluster

ACS Cluster acts as a place to stage the latest build of the
application.

Used to verify the build before pushing to production.

  * Prior to ACS preview use our development template
    * https://github.com/anhowe/scratch/tree/master/mesos-marathon
  * After ACS preview use the ACS REsource Provider
    * TODO: Update once ACS private preview is available
--

# ACS Cluster Setup: Jumpbox

  * SSH into cluster jumpbox opening a tunnel for VNC
  * If you are on Mac or Linux run the following command

```
ssh -L 5901:localhost:5901 azureuser:YOUR_JUMPBOX_URL
```

  * For Windows install Putty and follow [Anthony Howe's guide](https://github.com/Azure/azure-quickstart-templates/blob/master/ubuntu-desktop/README.md#accessing-from-windows)
  * {OPTIONAL] configure the Linux VM using the commands below
    * note this installs software and changes some configs
    * You might prefer to read the script and do things manually
    * Or fork my repo and customize the script for preference

```
git clone https://github.com/rgardler/linux-config.git
./linux-config/configure.sh
```
--

# ACS Cluster Setup: Jumpbox Desktop

  * Install RealVNC desktop client on your demo machine
  * Connect to localhost:1in RealVNC client
  * Open Firefox and create the following tabs
    * http://master1:5050
    * http://master1:8080

## Details

As a convenience we will be using VNC to connect to the Mesos web UI.

Verify you can see the expected number of Agents (slaves)

For details on how to do this installation see https://github.com/Azure/azure-quickstart-templates/blob/master/ubuntu-desktop/README.md#accessing-from-windows

---

# Demo Phase 1: Developer Workflow

## Details

In this phase of the demo we see the developer making a change to the
app, verifying it and pushing it to version control.

---

# The demo application

  * http://YOUR_DNS.YOUR_REGION.cloudapp.azure.com
  * A simple PHP web front-end
  * Connects to a Java Backend (REST API)
  * Front end is load balanced

## Details

We are looking at the demo running on the Azure Container Service, but
we won't focus on that now. We'll come back to it later. For now we
just want to see it running.

Headings and first hostname is from the PHP applicaiton.

Information below the first heading is from the Java REST API.

There is a load balancer for the web front-end too, but we only have a
single web container right now so it does nothing.

---

# The Application on the Dev Machine

  * http://localhost
  * Make an edit in index.php
  * Refresh the page
  * `git commit -am "a simple edit for a live demo"`

## Details

Now we can see the application is running on our local dev machine as
well.

Switching to the terminal we can see (in the bottom section) the three
containers running. In the top part of the terminal there is an editor
with the index.php file open.

We'll make a trivial edit to this file (e.g. change the first h1).

Refreshing the browser we can see the change immediately. This gives
us a fast development cycle. 

We're happy with the change so we'll commit it to the code repository
so others can review it and work with it.

---

# Demo Stage 2: Dev Vs Production

## Details

This section is really here to fill the 2-3 minutes it takes for the
applicaiton to be tested and deployed to staging, but it serves a useful purpose too.

Here we will outline the need to manage applications across multiple regions and clusters.

---

# About that Staging Cluster

  * Running on the dev machine can only take us so far
  * Production environemnt need to be robust and scalable
  * Staging environments need to be as close as possible to the Prod environemnt

---

# Introduction to Azure Container Service

  * A convenient way to create a cluster of Docker Hosts
  * Highliy available
  * Application deployment through Docker
  * Application orchestration through Apache Mesos

---

# Creating a Cluster

  * Portal
  * CLI, using ARM

---

# ACS as a Staging Cluster

  * Earlier we saw our application running on Azure
  * This was on an ACS cluster
  * We use standard open source tooling
    * Docker, Compose and Swarm
    * Marathon and Apache Mesos
  * Lets take a look at it

---

Demo Phase 3: A tour of ACS

---

# Tour of ACS

  * http://mvpdemo.eastus.cloudapp.azure.com:5050
  * Number of agents running
  * The application containers are running

--- 

# Lets take another look at the application on the cluster

  * http://mvpdemo.eastus.cloudapp.azure.com
  * See the change we made!
  * What happened here?

---

# Scaling

  * We have a cluster, lets scale up
  * Use Marathon UI to scale web container
  * refresh browser, see the PHP HOST changing

## Details

NOTE: at the time of writing we can scale up the images but the HA Proxy load balancer does not work. Need to remove it and allow the Azure LB to do it's job

---

Demo Phase 4: CI/CD

---

# CI/CD with Jenkins

  * We have a CI/CD server in the cluster
    * This is not a standard part of ACS
    * It's something we built in
  * http://mvpdemoci.eastus.cloudapp.azure.com:8081
  * It detected changes in GitHub
  * Built and tested the application
  * Published the updated containers to Docker Hub
    * With "stage" tag
  * Instructucted Azure Container Service to update the staged app

---

# Summary

  * Containers provide service portability
  * Apache Mesos and friends provide orchestration portability
  * Azure Container Service brings them together with the best cloud
  * Reaching preview very soon, building out new features all the time

