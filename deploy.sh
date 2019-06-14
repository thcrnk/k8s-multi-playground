#!/usr/bin/env bash
docker build -t thcrnk/multi-client:latest -t thcrnk/multi-client$SHA -f ./client/Dockerfile ./client
docker build -t thcrnk/multi-server:latest -t thcrnk/multi-server$SHA -f ./server/Dockerfile ./server
docker build -t thcrnk/multi-worker:latest -t thcrnk/multi-worker$SHA  -f ./worker/Dockerfile ./worker
docker push thcrnk/multi-client:latest
docker push thcrnk/multi-server:latest
docker push thcrnk/multi-worker:latest

docker push thcrnk/multi-client:$SHA
docker push thcrnk/multi-server:$SHA
docker push thcrnk/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=thcrnk/multi-server:$SHA
kubectl set image deployments/client-deployment server=thcrnk/multi-client:$SHA
kubectl set image deployments/worker-deployment server=thcrnk/multi-worker:$SHA