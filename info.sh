#!/bin/bash

echo "Docker Containers:"
docker ps -a

echo -e "\nDocker Images:"
docker images

echo -e "\nDocker Volumes:"
docker volume ls

echo -e "\nDocker Networks:"
docker network ls
