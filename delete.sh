# Deleting all containers
docker rm -f $(docker ps -aq)
# Deleting all images
docker rmi -f $(docker images -aq)



# Deleting specific version
#!/bin/bash

# Prompt the user for version input
read -p "Enter the version to delete: " version

# Stop and remove containers based on the container name pattern
docker stop $(docker ps -a -q --filter name=chat-app-container-${version})
docker rm $(docker ps -a -q --filter name=chat-app-container-${version})
