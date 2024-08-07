terraform {
  backend "gcs" {
    bucket = "bigquery-cicd-sample"
    prefix = "state"
  }
}

provider "google" {
  project = "tw-rd-tam-jameslu"
  region  = "asia-east1"
}