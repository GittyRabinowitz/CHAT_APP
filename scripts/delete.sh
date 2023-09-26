#!/bin/bash
docker stop chat-app-run
if [ $# -eq 0 ]; then
    docker rmi -f chat-app
else
    docker rmi -f chat-app:$1
fi
docker rm -f chat-app-run


#    # Deleting all images
#     docker rmi -f $(docker images -aq)
#     # Deleting all containers
#     docker rm -f $(docker rm -aq)