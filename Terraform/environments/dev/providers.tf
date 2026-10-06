terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.20.0"
    }
  }

  # If you want to use HCP Terraform / Terraform Cloud remote state:
  # cloud {
  #   organization = "Learning-TeraForm33"
  #   workspaces {
  #     name = "terraform-learning-dev"
  #   }
  # }
}

provider "aws" {
  region = var.aws_region
}
