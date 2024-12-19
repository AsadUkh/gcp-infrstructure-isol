variable "project_id" {
  description = "GCP Project ID"
  default     = "utopian-sky-444112-d5"
}

variable "primary_region" {
  description = "Primary region for resources"
  default     = "us-central1"
}

variable "secondary_region" {
  description = "Secondary region for resources"
  default     = "us-east4"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "my-multi-region-vpc"
}
