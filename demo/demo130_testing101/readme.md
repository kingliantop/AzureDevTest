# Objectives

1. See how tests can be provided in a separate container
2. Explore basic integration test containers
3. Tests are run whenever `docker-compose up` is executed

---

# Starting the demo

  * `sudo ./demo/demo130_testing/prepare.sh`
  * On startup we will have 4 containers
    * Web application
    * Rest application
    * Load Balancer (for Web application)
    * Load Test
    * Integration Test
  * The TMux session will have two windows available, one showing test results
  * Load Test and Integration Test are the ones we are interested in

---

# Benchmark Web Container

  * load_test container
  * Uses Apache HTTP server benchmarking tool
  * `docker logs azuredevtestdeploy_load_test1`
    * Note the number of requests per second

# Scale the web cluster

  * `docker-compose scale web=25`
  * `docker-compose up -d` (restarts the load test container)
  * It will take a little while to run, so lets look at some other tests

# Integration tests

  * "integration_test" container
  * Contains a simple shell script
  * Tests whether the index.php page has a valid REST response
  * `docker logs azuredevtestdeploy_integration_test_1`

# Breaking the integration test

  * Edit tests/test_test.sh
  * Change the text "<p>REST hostname is .+</p>"
  * `docker-compose up -d`
  * `docker logs azuredevtestdeploy_integration_test_1`

# Checking our performancs

  * Buy now the performance tests have probably completed
  * `docker logs azuredevtestdeploy_load_test1`
  * Note the number of requests per second, it's higher right?
    * It's more, right?
