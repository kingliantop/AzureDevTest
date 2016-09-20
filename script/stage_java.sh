###########################################
# Build and stage the Java application
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

echo "Staging Java application version $REST_STAGE_VERSION on $STAGE_MACHINE_NAME"
docker info

cd java

# Build the container to ensure we pick up any changes
docker build -t rest:$REST_STAGE_VERSION .

# Stop, remove and restart the container
echo "Stopping any running (staged) REST application container on $STAGE_MACHINE_NAME"
docker stop stage_rest
echo "Removing any previously (staged) REST application container on $STAGE_MACHINE_NAME"
docker rm stage_rest
echo "Running a REST application container"
docker run -t -d -p 8080:8080 --name=stage_rest rest:$REST_STAGE_VERSION

cd ..
