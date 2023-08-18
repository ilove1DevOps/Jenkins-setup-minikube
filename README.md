1. Setup the Minikube using the docker driver.
2. Then save the ca.crt, client.key, client.crt into a directory, Note every time these values will change.
3. ```docker network ls```, use the same network as minikube is assigned
4. ```docker run --name jenkins-server-final --network minikube  -p 8082:8080 -p 50001:50000 --mount type=bind,source="/home/piyush/Desktop/jenkins",destination="/var/jenkins_home" --mount type=bind,source="/var/run/docker.sock",destination="/var/run/docker.sock" --cpus=2 --memory=2g piyushdhir121/jenkins-server:v2```
5. use ```docker cp client.crt dcdb8d395291:/root/.kube``` ```docker cp client.key dcdb8d395291:/root/.kube``` ```docker cp ca.crt dcdb8d395291:/root/.kube```
6. go inside the container and see these files are present or not.
7. ```kubectl get po```
8. ![image](https://github.com/ilove1DevOps/Jenkins-setup-minikube/assets/128630024/ebf38d98-72cc-4f3b-af87-aa746f80e666)
9. now create the script to run the job of the jenkins.
10.
```
pipeline {
    agent any

    stages {
        stage('Run kubectl get po') {
            steps {
                sh 'kubectl get po'
            }
        }
    }
}
```

11. ![image](https://github.com/ilove1DevOps/Jenkins-setup-minikube/assets/128630024/637bded8-b58d-4859-bb08-b1b10d330c23)
12.
```
#!/bin/bash

# Define ANSI escape codes for formatting
bold_green='\033[1;32m'
reset_color='\033[0m'

# Run Jenkins Docker container and get its ID
#container_id=$(docker run --name jenkins-server-final --network minikube -p 8082:8080 -p 50001:50000 --mount type=bind,source="/var/run/docker.sock",destination="/var/run/docker.sock" --cpus=2 --memory=2g -d piyushdhir121/jenkins-server:v2)
container_id=$(docker run --name jenkins-server-final --network minikube -p 8082:8080 -p 50001:50000 --mount type=bind,source="/home/piyush/Desktop/jenkins",destination="/var/jenkins_home" --mount type=bind,source="/var/run/docker.sock",destination="/var/run/docker.sock" --cpus=2 --memory=2g -d piyushdhir121/jenkins-server:v2)

echo -e "${bold_green}Container Created successfully with ID: $container_id${reset_color}"

# Create client.key, client.crt, and ca.crt files
kubectl config view -o jsonpath='{.users[0].user.client-key-data}' | base64 -d > client.key
kubectl config view -o jsonpath='{.users[0].user.client-certificate-data}' | base64 -d > client.crt
kubectl config view -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 -d > ca.crt

echo -e "${bold_green}client.key, client.crt, and ca.crt created and saved in the present directory${reset_color}"

# Create config file and save content from kubectl config view
kubectl config view > config

# Get the current working directory
current_dir=$(pwd)

# Modify paths of certificates in config file using the current directory
sed -i "s#$current_dir/client.key#/root/.kube/client.key#g" config
sed -i "s#$current_dir/client.crt#/root/.kube/client.crt#g" config
sed -i "s#$current_dir/c.crt#/root/.kube/ca.crt#g" config

echo -e "${bold_green}Modified paths in config file${reset_color}"

# Get container name for filtering
container_name="jenkins-server-final"

# Get container ID based on container name
container_id=$(docker ps -q --filter "name=$container_name")

# Copy files to the Jenkins Docker container
docker cp client.key "$container_id:/root/.kube"
docker cp client.crt "$container_id:/root/.kube"
docker cp ca.crt "$container_id:/root/.kube"

echo -e "${bold_green}Certificates copied successfully inside the container${reset_color}"

# Copy modified config file to the Jenkins Docker container
docker cp config "$container_id:/root/.kube"

echo -e "${bold_green}Modified config file copied successfully inside the container${reset_color}"
```


 
