#!/bin/bash
mkdir -p /home/ubuntu/.kube

microk8s enable dns
microk8s enable dashboard
microk8s enable storage

microk8s config > /home/ubuntu/.kube/config

wget https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.44/kpt_linux_amd64
sudo mv kpt_linux_amd64 /bin/kpt
chmod +x /bin/kpt

kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-system
kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-configsync
kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-webui

kpt live init nephio-system
kpt live init nephio-configsync
kpt live init nephio-webui

kpt live apply nephio-system --reconcile-timeout=15m --output=table
kpt live apply nephio-configsync --reconcile-timeout=15m --output=table
kpt live apply nephio-webui --reconcile-timeout=15m --output=table

kpt alpha repo register \
  --namespace default \
  --deployment=false \
  https://github.com/SimonTheLeg/nephio-example-packages.git

microk8s kubectl port-forward --namespace=nephio-webui --address 0.0.0.0 svc/nephio-webui 7007 &