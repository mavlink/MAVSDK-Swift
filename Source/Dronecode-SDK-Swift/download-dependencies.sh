#!/bin/bash

set -e # fail on errors

dependencies_filename=dronecode-sdk-swift-deps-latest.zip
unzip_dir=Dronecode-SDK-Swift/libs/dronecode-sdk-swift-deps-latest
echo "Start script to download dependencies..."

downloaded=false
if [ ! -f $dependencies_filename ]; then
    echo "Downloading DroneCore-Swift dependencies..."
    curl --progress-bar -O https://s3.eu-central-1.amazonaws.com/dronecode-sdk/$dependencies_filename;
    downloaded=true
fi

if [ ! -d /libs/ -o downloaded=true ]; then
    echo "Unzipping..."
    mkdir -p $unzip_dir
    unzip -o $dependencies_filename -d $unzip_dir
    echo "Finished"
fi
