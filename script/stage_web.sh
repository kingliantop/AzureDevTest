###########################################
# Build and run the web client application
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

echo "Staging web client application version $WEB_STAGE_VERSION on $STAGE_MACHINE_NAME"
eval "$(docker-machine env $STAGE_MACHINE_NAME)"
docker info

cd web

# Build the container to ensure we pick up any changes
docker build -t web:$WEB_STAGE_VERSION .

# Stop, remove and restart the container
echo "Stopping any running (staged) web application containers"
docker stop stage_web
docker stop stage_web1
docker stop stage_web2
echo "Removing any previously (staged) web application containers"
docker rm stage_web
docker rm stage_web1
docker rm stage_web2
echo "Running webapp containers"
docker run -t -d --link stage_rest:rest --name=stage_web1 web:$WEB_STAGE_VERSION
docker run -t -d --link stage_rest:rest --name=stage_web2 web:$WEB_STAGE_VERSION
echo "Running HAProxy load balancer"
docker run -d -p 80:80 --name=stage_web --link stage_web1:stage_web1 --link stage_web2:stage_web2 tutum/haproxy

cd ..
