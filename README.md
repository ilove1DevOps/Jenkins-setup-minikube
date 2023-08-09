1. Setup the Minikube using the docker driver.
2. Then save the ca.crt, client.key, client.crt into a directory, Note every time these values will change.
3. ```docker network ls```, use the same network as minikube is assigned
4. ```docker run --name jenkins-server-final --network minikube  -p 8082:8080 -p 50001:50000 --mount type=bind,source="/home/piyush/Desktop/jenkins",destination="/var/jenkins_home" --mount type=bind,source="/var/run/docker.sock",destination="/var/run/docker.sock" --cpus=2 --memory=2g piyushdhir121/jenkins-server:v2```
5. use ```docker cp client.crt dcdb8d395291:/root/.kube``` ```docker cp client.key dcdb8d395291:/root/.kube``` ```docker cp ca.crt dcdb8d395291:/root/.kube```
6. go inside the container and see these files are present or not.
7. ```kubectl get po```
8. ![image](https://github.com/ilove1DevOps/Jenkins-setup-minikube/assets/128630024/ebf38d98-72cc-4f3b-af87-aa746f80e666)
9. now create the script to run the job of the jenkins.
 
