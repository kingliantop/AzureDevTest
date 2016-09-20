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

echo "Staging load testing version on $DEV_MACHINE_NAME"
eval "$(docker-machine env $DEV_MACHINE_NAME)"

cd load_test

# Build the container to ensure we pick up any changes
docker build -t load_test .

# Stop, remove and restart the container
echo "Stopping any running (staged) load testing container"
docker stop dev_load
echo "Removing any previously (staged) load testing container"
docker rm dev_load
echo "Running a load testing container"
docker run -t -d -v $(pwd)/../ci/www/html:/var/www --link dev_web:web --name=dev_load load_test

cd ..
