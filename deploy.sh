docker build -t willdk3000/complex-client:latest -t willdk3000/complex-client:$SHA -f ./client/Dockerfile ./client
docker build -t willdk3000/complex-server:latest -t willdk3000/complex-server:$SHA -f ./server/Dockerfile ./server
docker build -t willdk3000/complex-worker:latest -t willdk3000/complex-worker:$SHA -f ./worker/Dockerfile ./worker

docker push willdk3000/complex-client:latest
docker push willdk3000/complex-server:latest
docker push willdk3000/complex-worker:latest

docker push willdk3000/complex-client:$SHA
docker push willdk3000/complex-server:$SHA
docker push willdk3000/complex-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=willdk3000/complex-server:$SHA
kubectl set image deployments/client-deployment client=willdk3000/complex-client:$SHA
kubectl set image deployments/worker-deployment worker=willdk3000/complex-worker:$SHA