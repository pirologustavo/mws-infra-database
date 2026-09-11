terraform {
  backend "s3" {
    bucket = "mws-terraform-state-2026"
    key    = "k8s/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "filtered" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}

resource "aws_eks_cluster" "mws_cluster" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::646417168660:role/LabRole"
  version  = "1.31"

  vpc_config {
    subnet_ids = data.aws_subnets.filtered.ids
  }
}

resource "aws_eks_node_group" "mws_nodes" {
  cluster_name    = aws_eks_cluster.mws_cluster.name
  node_group_name = "mws_nodes"
  node_role_arn   = "arn:aws:iam::646417168660:role/LabRole"
  subnet_ids      = data.aws_subnets.filtered.ids

  ami_type        = "AL2_x86_64"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [
    aws_eks_cluster.mws_cluster
  ]
}