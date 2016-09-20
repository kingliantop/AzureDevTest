import json
import yaml

compose= """
  lb:
    image: eeacms/haproxy
    ports:
      - "80:80"
      - "1936:1936"
    links:
      - web
  web:
    build: web
    ports:
      - "80"
    links:
      - rest
  rest:
    build: java
    ports:
      - "8080:8080"
  load_test:
    build: load_test
    links:
      - web
"""
print "Compose in:"
print yaml.dump(yaml.load(compose))

desired_marathon = """
{
  "id": "azure",
  "groups": [
    {
      "apps": [
        {
          "id": "web",
          "cpus": 0.5,
          "mem": 500,
          "instances": 1,
          "ports": [
            80
          ],
          "requirePorts": true,
          "container": {
            "docker": {
             "image": "azuredemo/web:azurecon",
             "network": "HOST"
            },
            "type": "DOCKER"
          },
          "dependencies": [
            "/azure/demo/rest"
          ]
        },
        {
          "id": "rest",
          "cpus": 1.0,
          "mem": 500,
          "instances": 1,
          "ports": [
            8080
          ],
          "requirePorts": true,
          "container": {
            "docker": {
              "image": "azuredemo/rest:azurecon",
              "network": "HOST"
            },
            "type": "DOCKER"
          }
        },
        {
          "id": "lb",
          "cpus": 0.5,
          "mem": 500,
          "instances": 1,
          "ports": [
            80
          ],
          "env": {
            "BACKENDS": "web-demo-azure.marathon.mesos:80"
          },
          "requirePorts": true,
          "container": {
            "docker": {
              "image": "eeacms/haproxy",
              "network": "HOST"
            },
            "type": "DOCKER"
          },
          "dependencies": [
            "/azure/demo/web"
          ]
        }
      ],
      "id": "demo"
    }
  ]
}
"""

print "Desired Marathon file"
print json.dumps(desired_marathon, indent=4, separators=(',', ': '))

# docker-compose does not provide a group id
# FIXME: group ID should be provided in the command line
group="azure"

