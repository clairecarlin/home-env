set -eou pipefail
name="$1"
docker pull "docker.io/radiasoft/$name:dev"
docker tag "docker.io/radiasoft/$name:dev" "v3.radia.run:5000/radiasoft/$name:dev"
sudo cat /root/.docker/config.json > ~/.docker/config.json
docker push "v3.radia.run:5000/radiasoft/$name:dev"
