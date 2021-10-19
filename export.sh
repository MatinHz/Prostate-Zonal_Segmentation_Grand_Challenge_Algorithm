#!/usr/bin/env bash

./build.sh

docker save am_zonal_zegmentation_gca | gzip -c > AM_Zonal_Zegmentation_GCA.tar.gz
