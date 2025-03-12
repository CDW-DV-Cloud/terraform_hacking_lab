terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.25.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.42.0"
    }

  }
}
provider "aws" {
  region = var.region
}
provider "tfe" {
  token = var.tf_token
}