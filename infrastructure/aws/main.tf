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