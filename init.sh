docker build -t mychatappimg . --build-arg ENVIRONMENT=development
# docker build -t mychatappimg .
docker run -p 5000:5000 mychatappimg

