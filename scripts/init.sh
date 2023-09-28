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




# with cloud
version=$1


gcloud config unset auth/impersonate_service_account

gcloud compute ssh gittyrabinowitz1@gitty-first-instance --project grunitech-mid-project --zone me-west1-a

gcloud auth configure-docker me-west1-docker.pkg.dev

docker volume create chat-app-data

# docker pull me-west1-docker.pkg.dev/grunitech-mid-project/gittyrabinowitz-chat-app-images/chat-app:22.0.0
docker pull me-west1-docker.pkg.dev/grunitech-mid-project/gittyrabinowitz-chat-app-images/chat-app:${version}

# docker run -p 80:5000 me-west1-docker.pkg.dev/grunitech-mid-project/gittyrabinowitz-chat-app-images/chat-app:22.0.0
docker run -p 80:5000 me-west1-docker.pkg.dev/grunitech-mid-project/gittyrabinowitz-chat-app-images/chat-app:${version}