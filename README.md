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
kubectl apply -f minikube/minikube-namespace.yaml
```
Check with
```
kubectl get namespaces
```

# To create the persistent volume
```
kubectl apply -f minikube/minikube-persistentVolume.yaml
```
Check with
```
kubectl get pv
```
# To create the persistent volume claims
```
kubectl apply -f minikube/minikube-persistentVolumeClaim.yaml
```
Check with
```
kubectl get pvc --namespace neo4j-namespace
```

# Deploy neo4j version 4
```
kubectl apply -f neo4j/neo4j4-deployment.yaml 
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

To figure out what is the URL to access the webfront end use

```
minikube --namespace neo4j-namespace service neo4j-service –url
```

# To export the data using graphml
Run this Cypher-statement in the neo4j-Webfrontend
```
WITH "export-neo4j4.graphml" AS filename
CALL apoc.export.graphml.all(filename, {useTypes:TRUE, storeNodeIds:FALSE})
YIELD file
RETURN file;
```
after that export the saved data to your file system.

# Delete the neo4j version 4
```
Removing statefulset
kubectl --namespace neo4j-namespace delete statefulsets.apps neo4j-database
removing service
kubectl --namespace neo4j-namespace delete service neo4j-service
check if deleted
kubectl --namespace neo4j-namespace get all
```
# Create secret for neo4j version 5
```
kubectl apply -f neo4j5-on-kubernetes/neo4j/neo4j-secret.yaml
```
# Create neo4j version 5 database
```
kubectl apply -f neo4j5-on-kubernetes/neo4j/neo4j5-deployment.yaml 
```
# Import the graphml data
Using this Cypher-statement
```
CALL apoc.import.graphml("export-neo4j4.graphml", {readLabels: true})
```

# Deploy neo4j version 5 to the neo4j-backup namespace
```
kubectl apply -f neo4j5-on-kubernetes/backup/neo4j5-secret-backup.yaml
kubectl apply -f neo4j5-on-kubernetes/backup/neo4j5-deployment-backup.yaml
```
# Check the connection to the HTTP API
by placing this curl statement into your terminal
```
curl -X POST http://192.168.49.2:30047/db/neo4j/tx/commit -H "Content-Type:application/json" -d "{\"statements\":[{\"statement\":\"match (n) return count(n)\"}]}" -H "Authorization: bmVvNGo6MTIzNDU2Nzg="
```
use this similar statement into your Cronjob
```
curl -d '{"statements": [ {  "statement" : "WITH \"backup.graphml\" AS filename CALL apoc.export.graphml.all(filename, {useTypes:TRUE, storeNodeIds:FALSE}) YIELD file RETURN file;" } ]}' -H "Authorization: Basic bmVvNGo6MTIzNDU2Nzg=" -H "Content-Type: application/json" -X POST http://192.168.49.2:30047/db/neo4j/tx/commit
```

# Deploy the Cronjob
```
kubectl apply -f neo4j5-on-kubernetes/backup/neo4j5-backup-job.yaml
```
# Derive a job from the Cronjob for immediate execution
```
kubectl --namespace neo4j-backup create job --from=cronjob/neo4j-backup neo4j-backup-once
```

# Check for the availability of the created backup file
by accessing the database backend and navigating to the import folder
```
kubectl --namespace neo4j-backup exec -it neo4j-database-0  -- /bin/sh
```

# To reset anything you did and start from scratch
```
minikube delete
```





