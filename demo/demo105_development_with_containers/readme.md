# Objectives

1. Illustrate how a real application can be built 
2. Demonstrate a workflow for such an application

---

# The Application

* Web front-end (PHP)
* REST back-end (Java)
* Load Balancer on web front-end

---

# Describe the Container

* Web Front-end Dockerfile 

    FROM php:5.6-apache
    COPY ./www /var/www/

---

# Build the container

    docker build -t web web

---

# Build and Deploy the Application

    ./script/dev.sh
    http://MYHOST

* Builds each container
* Stops any running containers
* Runs each container

---

# Edit Web Front-End

    vi web/www/html/index.php
    ./script/dev_web.sh
    http://MYHOST

---

# Explore Further?

* Source code is in github
  * https://github.com/rgardler/AzureDevTestDeploy

