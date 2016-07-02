#!/bin/bash

set -ex

docker rmi apachehost || true
docker build -t apachehost:latest .

