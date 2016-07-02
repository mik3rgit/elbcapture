#!/bin/bash

if [ ! -d /home/ec2-user/mongodata ]; then
    mkdir -p /home/ec2-user/mongodata
fi

# Stop any running containers
docker rm -v -f apache mongodb

# Launch MongoDB
docker run -d --name mongodb -p 27017:27017 -v /home/ec2-user/mongodata:/data/db mongo:3.2.7

# Launch Apache
docker run -d --name apache -p 8080:80 --link mongodb:mongodb apachehost:latest

