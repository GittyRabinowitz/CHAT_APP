# simple commands
# docker build -t mychatappimg .
# docker run -p 5000:5000 --name mychatappcontainer mychatappimg


# commands for limit cpu and memory utilization in containers
# docker build -t mychatappimg .
# docker run -p 5000:5000 --name my_container --memory=1g --memory-reservation=512m --cpus=1 --cpuset-cpus=2 mychatappimg



# docker build -t mychatappimg -f large.dockerfile .

# docker build -t mychatappimg -f mid.dockerfile .

#docker build -t mychatappimg:v0.0.0 .


# commands for init with version passed as an argument
# requestedVersion=$1
# docker build -t mycoolimg:$requestedVersion .
# docker run -p 5000:5000 --name my_container mycoolimg

# 8 זה לא עובד:
# commands for building the bonus.dockerfile
# docker build -t mychatappimg -f bonus.dockerfile .
# docker run -p 5000:5000 --name mychatappcontainer mychatappimg


# # 9
# # Modify init.sh that it will get as a user input the version to build and run.
# version='latest'
# if [ $# -nq 0 ]; then
#   # Arguments were passed, so use them
#     version=$1
# fi
# docker build -t my-chat-app:${version} .
# docker run -p 5000:5000 --name mychatappcontainer my-chat-app:${version}


# # 10
# # Run the container with volume mounts
# #!/bin/bash
# version='latest'
# if [ $# -ne 0 ]; then
#   # Arguments were passed, so use them
#     version=$1
# fi

# docker build -t my-chat-app:${version} .
# docker run -p 5000:5000 --name mychatappcontainer -v "C:/Users/This_User/Documents/try 19-09/ChatAppProject-python-docker/rooms":/app/rooms -v "C:/Users/This_User/Documents/try 19-09/ChatAppProject-python-docker":/app/users my-chat-app:${version}






#!/bin/bash

version='latest'
if [ $# -ne 0 ]; then
  # Arguments were passed, so use them
    version=$1
fi

# Get the VM instance IP address
vm_ip=$(gcloud compute instances list | grep gitty-first-instance | awk '{print $4}')

# Connect to the VM instance via ssh
ssh gittyrabinowitz1@${vm_ip} << EOF

# Pull the specified versioned image from the Artifact registry
docker pull artifactregistry.googleapis.com/Grunitech Mid Project/my-chat-app:${version}

# Run the image
docker run -p 5000:5000 --name mychatappcontainer -v "C:/Users/This_User/Documents/try 19-09/ChatAppProject-python-docker/rooms":/app/rooms -v "C:/Users/This_User/Documents/try 19-09/ChatAppProject-python-docker":/app/users artifactregistry.googleapis.com/my-project/my-chat-app:${version}

EOF

