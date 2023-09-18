# Stage 1: Build Application

# Set the base image (host OS) to python:3.8-slim
FROM python:3.8-slim AS build-stage

# Update certificates
RUN update-ca-certificates

# Set environment to development
ENV FLASK_ENV development

# Set environment variable for rooms directory path
ENV ROOMS_PATH "rooms/"

# Set environment variable for users file
ENV CSV_USERS_PATH "users.csv"

# Set the working directory in the container
WORKDIR /code

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install dependencies
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt

# Install Flask and other necessary dependencies
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org Flask

# Copy the content of the local src directory to the working directory
COPY . .

# Stage 2: Create a lightweight runtime image using python:alpine

# Set the base image to python:alpine
FROM python:alpine AS runtime-stage

# Copy the code from the build-stage image
COPY --from=build-stage /code /code

# Set the working directory in the container
WORKDIR /code

# Add health checks
HEALTHCHECK --interval=10s --timeout=3s CMD wget -q --spider http://localhost:5000/health || exit 1

# Command to run on container start
CMD ["python3", "./chatApp.py"]
