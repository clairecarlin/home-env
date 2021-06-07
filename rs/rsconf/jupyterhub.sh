docker tag "$1" "v3.radia.run:5000/radiasoft/jupyterhub:dev"
sudo cat /root/.docker/config.json > ~/.docker/config.json
docker push "v3.radia.run:5000/radiasoft/jupyterhub:dev"
