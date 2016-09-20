# Objectives

1. Demonstrate how fast containers can be started and stopped
2. Learn basic commadns for managing containers

---

# Environment

* Linux client (could be Windows)
* Docker host installed on this machine
* Two panes on screen
   * Main work pane
   * Watch on docker machine

---

# Hello World

    docker run hello-world
    docker ps -a

---
# Hello Web World
    
    docker run -d -p 80:80 tutum/hello-world
    http://MY_HOST

---

# Lots of Containers

    for i in {1..15}; do docker run -d -p 80 tutum/helloworld; done
    
---

# Cleanup

    docker rm -f $(docker ps -qa)


