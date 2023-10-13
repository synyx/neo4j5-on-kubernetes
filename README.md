# To create a minikube cluster

To install minikube I followed See [these](https://minikube.sigs.k8s.io/docs/start/) instructions.
Therefore you need to:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube start
```
The startup will take a short time.

# To create the namespace
```
kubectl apply -f git/neo4j5-on-kubernetes/minikube/minikube-namespace.yaml
```
Check with
```
kubectl get namespaces
```

# To create the persistent volume
```
kubectl apply -f git/neo4j5-on-kubernetes/minikube/minikube-persistentVolume.yaml
```
Check with
```
kubectl get pv
```
# To create the persistent volume claims
```
kubectl apply -f git/neo4j5-on-kubernetes/minikube/minikube-persistentVolumeClaim.yaml
```
Check with
```
kubectl get pvc --namespace neo4j-namespace
```

# Deploy neo4j version 4
```
kubectl apply -f git/neo4j5-on-kubernetes/neo4j/neo4j4-deployment.yaml 
```
Check with
```
kubectl --namespace neo4j-namespace get all
```
This may take a while.
To debug the startup of the database pod:
```
kubectl --namespace neo4j-namespace logs neo4j-database-0
```
or
```
kubectl --namespace neo4j-namespace describe pod neo4j-database-0
```

# Create some data in the database
Use the default login for neo4j version 4 (neo4j:neo4j).
Open up the files NodeCreation.cypher and Relationship.cypher and copy/paste the statements to the webfrontend and executed it there.




# To reset anything you did and start from scratch
```
minikube delete
```





