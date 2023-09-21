#!/bin/bash

# Prune all containers
docker container prune -f

# Prune all images (both dangling and unused)
docker image prune -af

# Prune all volumes
docker volume prune -f

# List and prune all volumes (including those in use)
# docker volume ls -q | xargs -r docker volume rm

# Prune all networks
docker network prune -f
