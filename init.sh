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


# 9
# Modify init.sh that it will get as a user input the version to build and run.
# read -p "Enter the version to build and run: " requestedVersion
# docker build -t mychatappimg:$requestedVersion .
# docker run -p 5000:5000 --name mychatappcontainer mychatappimg:$requestedVersion



# 10
# Run the container with volume mounts
docker build -t my-chat-app .
docker run -p 5000:5000 -v "C:/Users/This_User/Documents/try 19-09/ChatAppProject-python-docker/rooms":/app/rooms -v "C:/Users/This_User/Documents/try 19-09/ChatAppProject-python-docker":/app/users my-chat-app

