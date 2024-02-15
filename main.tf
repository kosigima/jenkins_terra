terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "MK-user4" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name="user4_deployer-key"
  
  count=1
  tags = {
    Name = "Mk-infra-${count.index}",
    role=count.index==0?"zero":(count.index<3?"lessThan3":"moreThan3")
  }
}

output "ips" {
    value = aws_instance.MK-user4.*.public_ip
}