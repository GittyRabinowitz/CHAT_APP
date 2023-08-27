docker build -t mychatappimg . --build-arg ENVIRONMENT=development
docker run -p 5000:5000 mychatappimg

