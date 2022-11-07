#WARNING: THIS IS PROOF OF CONCEPT ON A CLEAN ENVIORNMENT. 
#PREVIOUS MONGO VOLUMES IN YOUR ENVIRONMENT MAY CORRUPT YOUR BUILD
#This file recreates the slimming process. The slimmed images can instead be automatically pulled from Dockerhub as seen in the docker-compose-slim.yaml.

#Remove old volume using below command, if it fails, remove container id listed in error output.
#docker volume rm to-do-app_db-data #clear old db data

cp .env.example .env #make env file
export $(cat .env| xargs) #export them as vars
docker pull abdennour/dotenv-to-js-object:4ea #pull fat frontend sidecar
docker pull bitnami/mongodb:4.4.1 #pull fat db
docker build -t abdennour/go-to-do-api:rc server/ #build fat api
docker build -t abdennour/go-to-do-frontend:rc client / #build fat frontend
docker-slim build --show-clogs --compose-file docker-compose-dev.yaml \ #build slim frontend
 --target-compose-svc frontend  --dep-include-compose-svc-deps  --tag scicchino/go-to-do-frontend-slim #use deps
 /
docker-slim build --show-clogs --compose-file docker-compose-dev.yaml \ #build slim api
 --target-compose-svc api --http-probe-off  --tag scicchino/go-to-do-api-slim #disable probe
 /

docker-slim build --show-clogs --compose-file docker-compose-dev.yaml \ #build slim sidecar
 --target-compose-svc frontend-sidecar-env-gen --http-probe-off  --tag scicchino/env-to-js-sidecar-slim #disable probe
 /

docker-slim build --show-clogs --compose-file docker-compose-dev.yaml \ #build slim db
 --target-compose-svc db --http-probe-off --exec-file slim-commands.sh \ #disable probe, exec commands in container
 --include-path /docker-entrypoint-initdb.d/  --tag scicchino/go-mongo-slim #include extra file
 /
docker-compose -f docker-compose-slim.yaml up #launch all slimmed services, see localhost:8081 for app