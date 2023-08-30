#Stage 1: build Application

# set base image (host OS)
FROM python:3.8-slim AS reduce_docker_image

RUN update-ca-certificates
#set envaierment to development
ENV FLASK_ENV development
#set envaierment veriable to rooms dir path
ENV ROOMS_PATH "rooms/"
#set envaierment veriable to  users file
ENV CSV_USERS_PATH "users.csv"

# set the working directory in the container
WORKDIR /code
# copy the dependencies file to the working directory
COPY requirements.txt .
# install dependencies
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
#RUN pip install -r requirements.txt
# copy the content of the local src directory to the working directory
COPY . .
# command to run on container start


#stage 2: reduce docker image size runtime
FROM reduce_docker_image

# set the working directory in the container
WORKDIR /code

COPY --from=reduce_docker_image /code /code


CMD [ "python", "./chatApp.py" ]
