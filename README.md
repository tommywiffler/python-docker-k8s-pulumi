# python-docker-k8s-pulumi-example

## Prerequisites
Required downloads to run the deployment pipeline:
- Python
- Golang
- Docker
- minikube (or some other local kubernetes environment)
- pulumi
- Makefile
- helm (optional for monitoring)

Download these with your preferred method (i.e. binary, package manager). The following setup uses minikube and Docker for the required kubernetes cluster.

# Environment Setup

To setup your local kubernetes cluster, run the following commands in your shell:
```
minikube start --driver=docker
```
```
eval $(minikube -p minikube docker-env)
```
These commands will start up a local kubernetes cluster and configure the environment to use the onboard docker daemon within minikube.

# Deploy

To deploy the python API to your kubernetes cluster, run the following command in your shell:
```
make start
```
This will automatically build the docker images of each microservice, deploy them to the cluster via pulumi, expose the microservices via kubernetes services, and port-forward the api-microservice for API access.

# API
To access the API endpoints, navigate to the following URI's in your web browser or via http request in a tool like Postman.
```
http://127.0.0.1:5000/hello
```
```
http://127.0.0.1:5000/jobs
```

# Monitoring (Optional)
To setup monitoring on the cluster, run the following command in your shell:
```
make monitoring
```

This will install, run, and expose prometheus and grafana on your kubernetes cluster.

Some configuration is required to create and access a basic Grafana Monitoring dashboard.

First, run the following command in your shell, which will provide your grafana password for the UI login
```
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
Copy the produced password to your clipboard.
Run the next command to open up the Grafana UI.
```
minikube service grafana-np
```
Login to Grafana with username `admin` and the password in your clipboard.

Next you will need a Data Source. Navigate to the Data Source page in the Administration menu.
Create a Prometheus Data Source and enter the following URL into the URL field:
```
http://prometheus-server:80
```


Next you will need to create a Grafana Dashboard. Navigate to the Dashboard menu and select `import` from the `New` dropdown menu.
Enter in the id `6417` in the `import from grafana.com` field and click `load`.
Choose Prometheus as your data source and select `import`.

You now have a dashboard monitoring your local cluster metrics.

# Delete Deployment
To delete the app deployment and shutdown your kubernetes cluster, run the following command in you shell:
```
make stop
```



