locals {
  data_lake_bucket = "flights_data"
}

variable "project" {
  description = "Project for Data Engineering"
  default     = "boreal-quarter-455022-q5"
  type        = string
}

variable "location" {
  description = "Region for GCP resources"
  default     = "asia-southeast1"
  type        = string
}

variable "storage_class" {
  description = "Storage class type for my bucket"
  default     = "STANDARD"
}

variable "BQ_DATASET" {
  description = "Flights BigQuery Dataset"
  type        = string
  default     = "flights_data_bq"
}