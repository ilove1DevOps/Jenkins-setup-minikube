#!/bin/bash

# run jenkins Docker container and get its ID
container_id=$(docker run --name jenkins-server-final --network minikube -p 8082:8080 -p 50001:50000 --mount type=bind,source="/home/piyush/Desktop/jenkins",destination="/var/jenkins_home" --mount type=bind,source="/var/run/docker.sock",destination="/var/run/docker.sock" --cpus=2 --memory=2g -d piyushdhir121/jenkins-server:v2)
echo "Container Created successfully with ID: $container_id"

# create ca.crt file and paste content
cat /home/piyush/.minikube/ca.crt > ca.crt
echo "ca.crt is saved in the present directory"

# Create client.crt file and paste content
cat /home/piyush/.minikube/profiles/minikube/client.crt > client.crt
echo "client.crt is saved on the local directory"

# Create client.key file and paste content
cat /home/piyush/.minikube/profiles/minikube/client.key > client.key
echo "client.key is saved in the present directory"

# Create config file and save content from kubectl config view
kubectl config view > config
echo "config is saved in the present directory"

# Modify paths of certificates in config file
sed -i 's#/home/piyush/.minikube#/root/.kube#g' config
echo "Modified paths in config file"

# Get container name for filtering
container_name="jenkins-server-final"

# Get container ID based on container name
container_id=$(docker ps -q --filter "name=$container_name")
echo "Using Docker ID: $container_id"

# Copy files to the Jenkins Docker container
docker cp ca.crt "$container_id:/root/.kube"
echo "ca.crt is saved successfully inside the container"
docker cp client.crt "$container_id:/root/.kube"
echo "client.crt is saved successfully inside the container"
docker cp client.key "$container_id:/root/.kube"
echo "client.key is saved successfully inside the container"

# Copy modified config file to the Jenkins Docker container
docker cp config "$container_id:/root/.kube"
echo "Modified config is saved successfully inside the container"
