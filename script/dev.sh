####################################################################
# Build and Run all components on Development Machine
#
# If docker-machine is present assume that
# docker-machine is managing the docker
# hosts and us that. Otherwise use the same
# machine that this script is running on.
####################################################################

SCRIPT_PATH=$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")
SCRIPT_HOME=$(dirname $SCRIPT_PATH)

echo "source $SCRIPT_HOME/config.sh"
. $SCRIPT_HOME/config.sh

echo '####################################################################'
echo '# Build and Run Java REST API on the Dev machine ($DEV_MACHINE_NAME)'
echo '####################################################################'

script/dev_java.sh

echo '####################################################################'
echo '# Build and Run the Web Application on the Dev Machine ($DEV_MACHINE_NAME)'
echo '####################################################################'

script/dev_web.sh

echo '####################################################################'
echo '# Build and Run the Web CI Application on the Dev Machine ($DEV_MACHINE_NAME)'
echo '####################################################################'

script/dev_load.sh

echo '####################################################################'
echo '# View the results of the load testing with "docker logs dev_load"'
echo '####################################################################'

echo '####################################################################'
echo '# If all went well you can now visit your application'
echo '# at http://127.0.0.1:$DEV_WEBAPP_PORT'
echo '####################################################################'

