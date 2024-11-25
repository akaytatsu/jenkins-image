echo "TOKEN" | docker login --username akaytatsu --password-stdin

docker build -t akaytatsu/jenkins:1.5.1 -t akaytatsu/jenkins:latest -f Dockerfile . --no-cache
docker push akaytatsu/jenkins:1.5.1
docker push akaytatsu/jenkins:latest
