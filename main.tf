// in main.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.6.0"
    }
  }
}
provider "google" {
  credentials = file("./mylearnprojects-3e9472281925.json")
  project     = "mylearnprojects" // our GCP project_id
  region      = "us-central1"     // the region we want to use
  zone        = "us-central1-c"   // the zone we'd like to use
}
resource "random_id" "id" {
  byte_length = 4
}

//Here, we have provisioned a TF resource called "random_id" and given the instance a unique name "id".
resource "google_sql_database_instance" "terraform_sql" {
  name             = "terr-${random_id.id.hex}"
  database_version = "POSTGRES_12"
  region           = "us-central1"

  deletion_protection = false // important!!

  settings {
    tier      = "db-f1-micro"
    disk_size = 10
    backup_configuration {
      enabled = false
    }
  }
}
resource "google_sql_database" "db" {
  name     = "terraform-dev"
  instance = google_sql_database_instance.terraform_sql.name
  charset  = "utf8"
}
