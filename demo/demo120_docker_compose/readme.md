# Objectives

1. Replace our scripts with a configuration file
2. Demonstrate scaling the application with those scripts

---

# Configuration as Coder

  * Shell scripts are brittle
  * Shell scripts are platform dependent
  * Shell scripts are inflexible (or complex), e.g. scaling
  * Shell scripts are difficult to maintain

---

#  A Scalable Web Front0-ENd

  * Add HA Proxzy
  * Fire up new PHP containers to manaee inceased load

---

# Docker Compose

    web:
      build: web
      links:
        - rest
      restart: always

--

    lb:
      image: eeacms/haproxy
      ports:
        - "80:80"
        - "1936:1936"
      links:
        - web
      restart: always
    web:
      build: web
      links:
        - rest
      restart: always
    rest:
      build: java
      ports:
        - "8080:8080"
      restart: always

---

# Deploying With Compose

    docker-compose up -d
    docker-compose stop

---

# Scaling the Web App

    docker-compose scale web=5
    docker-compose scale web=3

---

    


