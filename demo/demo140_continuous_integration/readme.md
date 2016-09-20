# Objectives

1. Demonstrate how we can use Jenkins to do continuous integrationt testing

---

# Starting the demo

  * `sudo ./demo/demo140_continuos_integration/prepare.sh`
  * On startup we will have a single container running
    * Jenkins
  * This will monitor Git for changes and run tests when necessary

---

# View the Jenkins instance

```
http://YOURHOST:8081
```

---

# Trigger a build

  * Either commit and wait for up to 5 mins
  * Or, manual trigger a build in the UI