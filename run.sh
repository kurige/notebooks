#!/bin/sh

# Get the VM running...
boot2docker up

# Get the env we need exported properly
$(boot2docker shellinit)

docker-compose up
