#!/bin/sh

###########################################
# Build and run the web application.
#
# If docker-machine is present assume that
# docker-machine is managing the docker
# hosts and us that. Otherwise use the same
# machine that this script is running on.
###########################################

SCRIPT_PATH=$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")
SCRIPT_HOME=$(dirname $SCRIPT_PATH)

echo "source $SCRIPT_HOME/config.sh"
. $SCRIPT_HOME/config.sh

eval "$(docker-machine env $DEV_MACHINE_NAME)"
docker-machine env $DEV_MACHINE_NAME

cd web

# Build the container to ensure we pick up any changes
docker build -t web:latest .

# Stop, remove and restart the container
echo "Stopping any running dev container for web app"
docker stop dev_web
echo "Removing any previous dev container web app"
docker rm dev_web
echo "Running a web app dev container"
docker run -d -v $(pwd)/www/:/var/www -p $DEV_WEBAPP_PORT:80 --link dev_rest:rest --name=dev_web web:latest

cd ..
