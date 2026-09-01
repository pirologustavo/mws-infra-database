terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {} -> Ativar isso quando o S3 for criado
}

provider "aws" {
  region = var.aws_region
}