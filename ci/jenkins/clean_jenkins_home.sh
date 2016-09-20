#!/bin/bash

HOME="jenkins_home"

if [ -d "${HOME}.bak" ]; then
	 rm -rf "${HOME}.bak"
fi

mv $HOME ${HOME}.bak

mkdir $HOME
cd ${HOME}.bak

cp -R config.xml jobs ../${HOME}
#cp -R plugins/git* ../${HOME}/plugins

cd ../${HOME}

REMOVE_JOBS_FOLDERS=( "builds" "lastStable" "lastSuccessful" "nextBuildNumber" )
for file in "${REMOVE_JOBS_FOLDERS[@]}"
do
	rm -rf jobs/*/${file}
done
