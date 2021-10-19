#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

./build.sh

docker volume create am_zonal_zegmentation_gca-output

docker run --rm \
        --memory=1g \
        -v $SCRIPTPATH/test/:/input/ \
        -v am_zonal_zegmentation_gca-output:/output/ \
        am_zonal_zegmentation_gca

docker run --rm \
        -v am_zonal_zegmentation_gca-output:/output/ \
        python:3.7-slim cat /output/results.json | python -m json.tool

docker run --rm \
        -v am_zonal_zegmentation_gca-output:/output/ \
        -v $SCRIPTPATH/test/:/input/ \
        python:3.7-slim python -c "import json, sys; f1 = json.load(open('/output/results.json')); f2 = json.load(open('/input/expected_output.json')); sys.exit(f1 != f2);"

if [ $? -eq 0 ]; then
    echo "Tests successfully passed..."
else
    echo "Expected output was not found..."
fi

docker volume rm am_zonal_zegmentation_gca-output
