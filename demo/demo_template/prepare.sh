#!/bin/sh

# Demo parameters
DEMO_NAME=FIXME-demo-name

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

# Create tmux session
tmux kill-session -t $DEMO_NAME
mux $DEMO_NAME
