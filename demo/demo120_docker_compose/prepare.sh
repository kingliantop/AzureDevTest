tmux kill-session -t azurecon-demo3

docker stop $(docker ps -q)

docker-compose -f docker-compose-dev.yml up -d
docker-compose -f docker-compose-dev.yml scale web=1
docker-compose -f docker-compose-dev.yml stop
docker-compose -f docker-compose-dev.yml rm -f

mux azurecon-demo3
