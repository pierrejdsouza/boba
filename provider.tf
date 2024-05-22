terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.29.1"
    }
  }
#   backend "gcs" {
#    bucket  = "boba-bucket-tfstate"
#    prefix  = "terraform/state"
#  }
}

provider "google" {
  project = "rga-assessment"
  region = "ap-southeast1"
}