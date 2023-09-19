
# set base image (host OS)
FROM python:latest

RUN update-ca-certificates
#set envaierment to development
ENV FLASK_ENV development

# Set the environment variable for room path
ENV ROOMS_PATH /app/rooms

# Set the environment variable for user path
ENV USERS_PATH /app/users

# Create directories for rooms and users
RUN mkdir -p $ROOMS_PATH $USERS_PATH

# Make sure the user running the application has access to these directories
RUN chown -R 1000:1000 $ROOMS_PATH $USERS_PATH

# Define the volumes
VOLUME $ROOMS_PATH
VOLUME $USERS_PATH

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

CMD [ "python", "./chatApp.py" ]

