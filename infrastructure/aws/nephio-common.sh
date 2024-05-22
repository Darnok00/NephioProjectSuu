#!/bin/bash
sudo snap install microk8s --classic

sudo usermod -a -G microk8s ubuntu
newgrp microk8s