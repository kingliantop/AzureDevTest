#################################################################################
# Creates a Swarm for staging
#################################################################################

SCRIPT_PATH=$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")
SCRIPT_HOME=$(dirname $SCRIPT_PATH)

echo "source $SCRIPT_HOME/config.sh"
. $SCRIPT_HOME/config.sh

echo "Pulling Swarm container for use on the dev " $DEV_MACHINE_NAME
eval "$(docker-machine env $DEV_MACHINE_NAME)"
docker pull swarm

echo "Creating a Swarm cluster, using Docker Hub as the registry"
sid=$(docker run swarm create)
echo "Swarm cluster ID is " $sid
sed -i -e "s/SWARM_ID=.*$/SWARM_ID=$sid/g" $SCRIPT_HOME/config.sh
echo "The SWARM ID has been saved in your config.sh file"

echo "Creating Swarm Master as ${STAGE_MACHINE_NAME}" 
docker-machine create -d azure --azure-location="$AZURE_LOCATION" --azure-subscription-id="$AZURE_SUBSCRIPTION_ID" --azure-subscription-cert="$AZURE_CERT_NAME" --swarm --swarm-master --swarm-discovery token://$sid  ${STAGE_MACHINE_NAME}

echo "Creating a Swarm node named ${STAGE_MACHINE_NAME}-node-01"      
docker-machine create -d azure --azure-location="$AZURE_LOCATION" --azure-subscription-id="$AZURE_SUBSCRIPTION_ID" --azure-subscription-cert="$AZURE_CERT_NAME" --swarm --swarm-discovery token://$sid ${STAGE_MACHINE_NAME}-node-01

echo "Creating a Swarm node named ${STAGE_MACHINE_NAME}-node-02"      
docker-machine create -d azure --azure-location="$AZURE_LOCATION" --azure-subscription-id="$AZURE_SUBSCRIPTION_ID" --azure-subscription-cert="$AZURE_CERT_NAME" --swarm --swarm-discovery token://$sid ${STAGE_MACHINE_NAME}-node-02
