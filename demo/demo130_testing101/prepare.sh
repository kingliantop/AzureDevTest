#!/bin/sh

# Demo parameters
DEMO_NAME=acs-demo130

# Demo script location
SCRIPT_PATH=$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")
DEMO_HOME=$(dirname $SCRIPT_PATH)

# Configure TMux and Tmuxinator
mkdir ~/.tmuxinator
cp $DEMO_HOME/.tmuxinator/* ~/.tmuxinator

# Configure Docker
export DOCKER_HOME=
export DOCKER=

# Prepare Docker
docker-compose -f docker-compose-integration.yml stop
docker stop $(docker ps -aq)
docker rm $(docker ps -qa) 

# Start Docker containers
docker-compose -f docker-compose-integration.yml up -d

# Create tmux session
tmux kill-session -t $DEMO_NAME
mux $DEMO_NAME
