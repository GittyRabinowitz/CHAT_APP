
# docker build -t mychatappimg -f large.dockerfile .

# docker build -t mychatappimg -f mid.dockerfile .

#docker build -t mychatappimg:v0.0.0 .

# commands for init with version passed as an argument
# requestedVersion=$1
# docker build -t mycoolimg:$requestedVersion .
# docker run -p 5000:5000 --name my_container mycoolimg

# commands for limit cpu and memory utilization in containers
docker build -t mychatappimg .
docker run -p 5000:5000 --name my_container --memory=1g --memory-reservation=512m --cpus=1 --cpuset-cpus=2 mychatappimg




docker build -t mychatappimg .
docker run -p 5000:5000 --name mem-and-cpu-limit-demo --memory=1g --memory-reservation=512m --cpus=1 --cpuset-cpus=2 mychatappimg

