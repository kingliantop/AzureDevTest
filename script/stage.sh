####################################################################
# Build and Stage all components
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

case "$STAGE_MACHINE_TYPE" in
    azure)
        eval "$(docker-machine env $STAGE_MACHINE_NAME)"
        ;;
    swarm-azure)
        eval "$(docker-machine env --swarm $STAGE_MACHINE_NAME)"
        ;;
    *)
        echo "ERROR: Do not recognize Stage machine of type $STAGE_MACHINE_TYPE"
        ;;
esac

docker info
    
echo '####################################################################'
echo '# Build and Stage Java REST API'
echo '####################################################################'

source script/stage_java.sh

echo '####################################################################'
echo '# Build and Stage Web Application'
echo '####################################################################'

source script/stage_web.sh

echo '####################################################################'
echo '# Build and Stage Load Testing Container'
echo '####################################################################'

source script/stage_load.sh

