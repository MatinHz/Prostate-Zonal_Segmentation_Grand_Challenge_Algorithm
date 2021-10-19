#!/usr/bin/env bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

docker build -t am_zonal_zegmentation_gca "$SCRIPTPATH"
