terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  # Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  #  credentials = 
  project = var.project
  region  = var.location
}

resource "google_storage_bucket" "data-lake-bucket" {
  name     = "${local.data_lake_bucket}_${var.project}" # Concatenating DL bucket & Project name for unique naming
  location = var.location

  # Optional, but recommended settings:
  storage_class               = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }


}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.BQ_DATASET
  project    = var.project
  location   = var.location

}