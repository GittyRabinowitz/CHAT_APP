# Deleting all containers
docker rm -f $(docker ps -aq)
# Deleting all images
docker rmi -f $(docker images -aq)
