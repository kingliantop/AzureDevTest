#!/usr/bin/env node

fs = require("fs");
yaml = require("js-yaml");

// FIXME: All of the following should be parameters
composeFilename = "../../docker-compose.yml"
groupId = "azure"

try {
    var compose = yaml.safeLoad(fs.readFileSync(composeFilename, 'utf8'));
    console.log("Supplied Docker Compose file:");
    console.log(JSON.stringify(compose, null, "    "));
} catch (e) {
    console.log(e);
}

var marathon = {};
marathon.id = groupId;
marathon.groups = [];
apps = [];
for (var id in compose) {
  app = {};
  app.id = id;
  
  app.container = {};
  app.container.type = "docker";
  app.container.docker = {};
  // FIXME: what if compose has a build rather than image?
  app.container.docker.image = compose[id].image;
  // FIXME: what can we get from the Docker Compose file for Network?
  app.container.docker.network = "HOST"  
  
  app.ports = compose[id].ports;
  //FIXME: this is likely too simplistic, what should we do
  app.requirePorts = true;  

  //FIXME: Dependencies need to be massaged
  app.dependencies = []
  for (var link in compose[id].links) {
    app.dependencies.push(compose[id].links[link]);
  }
  
  app.cpu = 0.5;
  app.mem = 500;
  app.instances = 1;
  apps.push(app); 
}
marathon.groups.push(apps)
console.log("Generated Marathon file:");
console.log(JSON.stringify(marathon, null, "    "))

