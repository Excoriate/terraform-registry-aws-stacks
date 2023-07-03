terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48.0, < 5.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.1, < 0.8.0"
    }
  }
}
