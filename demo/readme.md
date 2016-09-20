Here you will find a number of demo's for this test application. Each demo is intended to be self contained and builds on the previous demo's. The folder for each demo has the same structure.

Once you have your machine set up to run the demo's (see Requirements for Running Demo's below) you can prepare your environment by running the `prepare.sh` from the chosen demo directory. The readme.md file will describe the demo script.

# Requirements for Running the Demo's

These demo's are designed to run on Linux. The Docker aspects should work on Mac and Windows, but some aspects of the prepare script may not work on those platforms because of missing dependencies.

TODO: Turning these demo's into containerized applications should remove platform dependence.

## Software Requried

It is assumed that you have the following software installed on your demo machine:

    * Docker
    * Docker-Compose
    * TMux
    * TMuxinator

# Strucutre of the Demo's

Each folder contains a single demo script and has the same structure.

## .tmuxinator

This folder containers one or more TMux session descriptions in the TMuxinator format. These will be copied into your `~/.tmuxinator` folder and used to configure your environment for the demo (see `prepare.sh`).

TODO: ensure prepare.sh copies these files into the correct place and that they use a suitable filename.

## prepare.sh

This script will prepare an environment for presenting the demo. It ensures your Docker environment is ready to start the demo (pre-pull images, build local images etc.). It also uses TMuxinator to configure the environment as defined in the `.tmuxinator` folder.

## commands.txt

This file includes the primary commands you will need to run in the demo. These commands will be placed in your history for easy retrieval.

## readme.md

This file describes the demo script and provides a set of slides (using `reveal.js`) that might be used when delivering the demo in a [presentation format](http://rgardler.github.io/2015/09/02/readme-files-that-are-also-slide-decks/).

## Dockerfile

Use the container defined in this Dockerfile to deliver the slides for this demo. For more information see my blog post [Readme Files That Are Also Slide Decks](http://rgardler.github.io/2015/09/02/readme-files-that-are-also-slide-decks/)

## Other files

Depending on the demo there may be other files in this folder that are used. These should be described in the demo's `readme.md` file.

# Demo's Available

The demo's are organized according to the level of expertise required to follow along:

    * 100 Level Demo's assume no significant knowledge
    * 200 Level Demo's assume basic Docker knowledge
    * 300 Level Demo's assume a good understanding of Docker and related technologies

Generally speaking higher numbered demo's assume that previous demo's are fully understood.

