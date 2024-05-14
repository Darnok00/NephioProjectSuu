# Project documentation
Project acronym: *Nephio* \
Authors: 
- Bartłomiej Chwast
- Karol Wrona
- Konrad Krzemiński
- Sławomir Tenerowicz

Year, Group: 2023/2024 Group 3

## Contents list
- [1. Introduction](#1-introduction)
- [2. Theoretical background/technology stack](#2-theoretical-backgroundtechnology-stack)
- [3. Case study concept description](#3-case-study-concept-description)
- [4. Solution architecture](#4-solution-architecture)
- [5. Environment configuration description](#5-environment-configuration-description)
- [6. Installation method](#6-installation-method)
- [7. How to reproduce - step by step](#7-how-to-reproduce---step-by-step)
     - [7.1. Infrastructure as Code approach](#71-infrastructure-as-code-approach)
- [8. Demo deployment steps:](#8-demo-deployment-steps)
    - [8.1. Configuration set-up](#81-configuration-set-up)
    - [8.2. Data preparation](#82-data-preparation)
    - [8.3. Execution procedure](#83-execution-procedure)
    - [8.4. Results presentation](#84-results-presentation)
- [9. Summary – conclusions](#9-summary-–-conclusions)
- [10. References](#10-references)

## Content
## 1. Introduction

Nephio is a cloud-native intent automation platform built on Kubernetes, designed to simplify the deployment and management of multi-vendor cloud 
infrastructure and network functions across large-scale edge deployments. By focusing on automation, Nephio streamlines the full lifecycle management
of entities, from provisioning to updates and decommissioning. It encompasses both network functions and the underlying infrastructure required to 
support them, enabling automation that adapts to changing requirements. Nephio is vendor-agnostic, fostering an ecosystem for innovation while 
ensuring interoperability. Its Kubernetes-based approach leverages declarative intent with continuous reconciliation, enabling efficient and scalable
automation. Nephio aims to accelerate the onboarding of network functions to production and reduce the costs associated with cloud adoption, 
ultimately enhancing agility in delivering services to customers [^1].
This project aims at creating demo presenting Nephio capabilities.

## 2. Theoretical background/technology stack

### Nephio - What It is? 
    
Nephio is a project that uses Kubernetes to automatically handle network tasks in cloud settings. It makes it easier to manage cloud infrastructure from different providers by using cloud-native ideas. This ensures that network services can grow, bounce back from issues, and be nimble when being set up and used on a large scale. The main aim of Nephio is to make using cloud and network infrastructure simpler and cheaper.

### What problem does Nephio solves?

Technologies like distributed cloud help us use computing resources across different locations easily, through the internet. But, the traditional ways of setting up and managing these resources don't work well with these new, flexible cloud systems. They can't easily adjust to changes or handle the complex setups involving different providers and locations.

Nephio is a solution that makes this easier. It uses newer methods that are better at dealing with the complexities of setting up and managing network services and the cloud infrastructure they run on, even when these involve many different providers and locations. It focuses on initially setting everything up and then, using Kubernetes (a system for automating application deployment, scaling, and management), it makes sure that the network keeps running smoothly even if there are problems, needs to grow, or changes in the cloud services.

### How Nephio works? 
Nephio tackles the big challenge by focusing on two main solutions:

- It uses Kubernetes at each site as a consistent tool to set up and manage both the distributed cloud and the network services running on it. This means no matter where your resources are, you're using the same system to control them.
- It offers an automation system that uses Kubernetes' smart, self-correcting approach. This system also allows configurations to be easily handled by computers. This helps manage the complex setups without getting overwhelmed.

### The use of Kubernetes in Nephio

The diagram below shows a system where Kubernetes helps automate and manage a telecom stack in three parts: 
- 1) the cloud setup
- 2) network function resources
- 3) network function setup. 
Nephio aims to create flexible and open Kubernetes templates, called CRDs, for each part, following telecom standards.

![alt text](images/diagram1.png)

### Overview of Nephio’s functional components

The belows diagram shows a system designed to manage automation smoothly across different locations, it consists of two parts:
- At the bottom part of the diagram, there's a layer called “Intent Actuation” that works on each site's own computer clusters to make sure the system does what it's supposed to do. 
- The top part of the diagram shows a setup that uses Kubernetes (a tool to manage applications) to handle automation tasks more efficiently. This part is called the "Orchestration Cluster," and it's a special Kubernetes cluster set up just for managing the automation processes.

![alt text](images/diagram2.png)

### Architecture 

The diagram below shows the recommended system architecture benefiting from Nephio, which is used to simplify the deployment and management of cloud infrastructure and network functions in large-scale deployments at the edge of the network. 

![alt text](images/diagram3.png)

## 3. Case study concept description

Nephio is usually known for its role in advanced networking, especially in 5G networks and network functions. But in our project, we want to keep things simple. Let's imagine we just want to show how Nephio can be useful in different situations. So we're setting up a basic web application. But instead of anything fancy, we're just serving a simple webpage using Nginx. That simple case is enough for use case study as it's all about demonstrating how Nephio can be handy even in basic setups, not just in big, complicated networks.

----

In our demo application we will showcase the usage of Nephio in configuring kubernetes workloads across multiple kubernetes clusters operating with different cloud providers. 
We are going to use AWS Cloud, Azure Cloud, local Kubernetes cluster and possibly GCP.

The demo will consist of the following steps:
1. Developer creates new workload configuration in main repository
2. Nephio’s porch component will create new branches in each “edge” cluster repository
3. Those changes will be approved using Nephio’s gui
4. configsync component will update the workload configuration in each kubernetes cluster

## 4. Solution architecture

![alt text](images/diagram-poc.png)

Our demo will be based on the following architecture:
- **Main repository** - the main repository on **GitHub** where the developer will create workload configuration
- **Edge repositories** - four repositories on **GitHub** for each edge cluster
- **Nephio management cluster** - an **microk8s** cluster based on **AWS EC2** where Nephio components will be deployed
- **Edge clusters**:
  - **microk8s** cluster based on **Azure VM** in **Azure Cloud**
  - **microk8s** cluster based on **AWS EC2** in **AWS Cloud**
  - **Local Kubernetes** cluster based on **minikube**
  - **GCP GKE** cluster based on **GCP VM** in **GCP**

Our goal is to present how Nephio can be used to manage workload configuration across various cloud providers and local Kubernetes clusters.
However, we are aware of possible limitations in terms of resources and costs, so we will focus on having at least two edge clusters.
One of them will be a local Kubernetes cluster, and the second one will be an **AWS** cluster.

## 5. Environment configuration description

### 5.1 AWS Infrastructure configuration

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "nephio-sg" {
  name        = "nephio-sg"
  description = "Allow inbound traffic"

  ingress {
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "nephio-master" {
  ami             = "ami-04b70fa74e45c3917"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = ["nephio-sg"]
  tags = {
    Name = "nephio-master"
  }
  root_block_device {
    volume_size = 20
  }
  user_data = file("nephio-master.sh")
  user_data_replace_on_change = "true"
}

resource "aws_instance" "nephio-edge" {
  ami             = "ami-04b70fa74e45c3917"
  instance_type   = "t2.small"
  key_name        = "vockey"
  security_groups = ["nephio-sg"]
  tags = {
    Name = "nephio-edge-1"
  }
  user_data = file("nephio-edge-1.sh")
  user_data_replace_on_change = "true"
}
```

The configuration of the projects will be saved in yaml. The so-called base configuration on which other projects will be based will be saved in teraforrm, that will load it all. It is thanks to Nephio that a change in the base configuration will allow automatic configuration changes in other repositories.
    

## 6. Installation method

### 6.1 Prepare EC2 on AWS

You can use prepared terraform scripts in the 'infrastructure/aws' directory.

Create at least two EC2 on AWS. One for *Master Cluster* and at least one for *Edge Cluster*. For our case *Master Clauses* is using t2.medium instance, and edge cluster is using t2.small instance. For simplicity the inboud rules accept all tcp traffic.

Installation guide for *Master Cluster*:

1. Install Kubernetes (in our case we were using microK8s deployment):
> sudo snap install microk8s --classic
2. Enable microk8s for ubuntu user
> sudo usermod -a -G microk8s ubuntu
> newgrp microk8s
3. Create $HOME/.kube directory
> mkdir .kube
4. Enable K8s addons (optional)
> microk8s enable dns 
> microk8s enable dashboard
> microk8s enable storage
5. Copy micro8Ks configruation to .kube configuration folder
> microk8s config > $HOME/.kube/config
6. Install KPT tool (https://kpt.dev/)
> wget https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.44/kpt_linux_amd64
> sudo mv kpt_linux_amd64 /bin/kpt
> sudo chmod +x kpt
7. Install Nephio packages
> kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-system
> kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-configsync
> kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-webui    
8. Initiazlize Nephio packages
> kpt live init nephio-system
> kpt live init nephio-configsync
> kpt live init nephio-webui
9. Apply Nephio packages
> kpt live apply nephio-system --reconcile-timeout=15m --output=table
> kpt live apply nephio-configsync --reconcile-timeout=15m --output=table
> kpt live apply nephio-webui --reconcile-timeout=15m --output=table
10. Forward Nephio UI
> microk8s kubectl port-forward --namespace=nephio-webui --address 0.0.0.0 svc/nephio-webui 7007
11. Register example packages repo
>kpt alpha repo register \
  --namespace default \
  --deployment=false \
  https://github.com/SimonTheLeg/nephio-example-packages.git
12. Configure edge cluster repositories
> kpt alpha repo register \
  --namespace default \
  --repo-basic-username=${GITHUB_USERNAME} \
  --repo-basic-password=${GITHUB_TOKEN} \
  --create-branch=true \
  --deployment=true \
  http url of your edge cluster repo 

13. Confirm registering repositories
> kubectl get repository

Instalation guide for *Edge Cluster*

1. Repeat steps 1-6 for *Master Cluster*
2. Install *config-sync* package
>kpt pkg get https://github.com/nephio-project/nephio-packages.git/nephio-configsync@v1.0.1
3. Modify *nephio-configsync/rootsync.yaml* file by replacing url in *spec.git.repo* to point to your edge repository
4. Apply *config-sync* package
> kpt live init nephio-configsync
> kpt live apply nephio-configsync --reconcile-timeout=5m
    

## 7. How to reproduce - step by step

    

### 7.1. Infrastructure as Code approach

    

## 8. Demo deployment steps:



## 9. Summary – conclusions

    

## 10. References

[^1]: [Learning with Nephio R1 - Episode 1 - Series Introduction](https://wiki.nephio.org/display/HOME/Learning+with+Nephio+R1+-+Episode+1+-+Series+Introduction)   
    

