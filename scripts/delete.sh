# # Deleting all containers
# docker rm -f $(docker ps -aq)
# # Deleting all images
# docker rmi -f $(docker images -aq)





# # Deleting specific version
# #!/bin/bash

# # Prompt the user for version input
# read -p "Enter the version to delete: " version

# # Stop and remove containers based on the container name pattern and based on version with filter
# docker stop $(docker ps -a -q --filter name=my-chat-app-${version})
# docker rm $(docker ps -a -q --filter name=my-chat-app-${version})

# Stop and remove containers based on the container name pattern and based on version with knowen name
# docker stop mychatappcontainer
# docker rm -f mychatappcontainer
# if [ $# -eq 0 ]; then
#     docker rmi -f my-chat-app
# else
#     docker rmi -f my-chat-app:$1
# fi

# with cloud

gcloud compute ssh gittyrabinowitz1@gitty-first-instance --project grunitech-mid-project --zone me-west1-a


# Stop and remove the running container 
docker stop "$CONTAINER_NAME" && docker rm "$CONTAINER_NAME"
# Delete the image 
docker rmi "$IMAGE_NAME"
