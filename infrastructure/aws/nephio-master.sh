#!/bin/bash
mkdir -p /home/ubuntu/.kube

microk8s enable dns
microk8s enable dashboard
microk8s enable storage

microk8s config > /home/ubuntu/.kube/config

wget https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.44/kpt_linux_amd64
sudo mv kpt_linux_amd64 /bin/kpt
chmod +x /bin/kpt

kpt pkg get --for-deployment https://github.com/nephio-project/catalog.git/nephio/core
kpt pkg get --for-deployment https://github.com/nephio-project/catalog.git/nephio/optional/webui

kpt live init core
kpt live init webui

kpt live apply core --reconcile-timeout=15m --output=table
kpt live apply webui --reconcile-timeout=15m --output=table

microk8s kubectl port-forward --namespace=nephio-webui --address 0.0.0.0 svc/nephio-webui 7007 &