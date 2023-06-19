start: build pulumi service expose

build:
	docker build -f Dockerfile.jobs -t jobs-app .
	docker build -f Dockerfile.api -t api-app .

pulumi:
	pulumi up --cwd ./dep-jobs/ --yes
	pulumi up --cwd ./dep-api/ --yes

service:
	kubectl apply -f env/jobs-svc.yml
	kubectl apply -f env/api-svc.yml

expose:
	kubectl port-forward service/api-app-svc 5000:5000

stop: pulumid serviced minikubestop

pulumid:
	pulumi destroy --cwd ./dep-jobs/ --yes
	pulumi destroy --cwd ./dep-api/ --yes

serviced:
	kubectl delete -f env/jobs-svc.yml
	kubectl delete -f env/api-svc.yml

minikubestop:
	minikube delete

monitoring:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm install prometheus prometheus-community/prometheus
	kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
	helm repo add grafana https://grafana.github.io/helm-charts
	helm install grafana grafana/grafana
	kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np

