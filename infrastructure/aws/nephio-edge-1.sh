  #!/bin/bash
sudo -u ubuntu -i
cd /home/ubuntu

sudo snap install microk8s --classic

sudo usermod -a -G microk8s ubuntu
newgrp microk8s
mkdir -p /home/ubuntu/.kube

microk8s enable dns
microk8s enable dashboard
microk8s enable storage

microk8s config > /home/ubuntu/.kube/config

wget https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.44/kpt_linux_amd64
sudo mv kpt_linux_amd64 /bin/kpt
chmod +x /bin/kpt

kpt pkg get https://github.com/nephio-project/nephio-packages.git/nephio-configsync@v1.0.1