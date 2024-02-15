terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    }
  }

  backend "s3" {
    bucket = "go-lambda-authorizer-tf-state"
    key    = "tofu.tfstate"
    region = "eu-west-1"
  }

  required_version = ">= 1.5.4"
}

provider "aws" {
  region     = var.AWS_REGION
}