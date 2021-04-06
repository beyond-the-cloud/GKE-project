provider "google" {
  project = var.project_id
  region  = var.region
}

# Get GKE VPC
data "google_compute_network" "vpc" {
  name = "${var.project_id}-vpc"
}

# Create private ip cidr block
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.vpc.id
}

# Create private vpc connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}


# webapp
resource "google_sql_database" "webapp" {
  name      = "csye7125"
  instance  = google_sql_database_instance.webapp_instance.name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_database_instance" "webapp_instance" {
  name             = "webapp-instance-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.db_tier
    disk_size         = var.db_disk_size

    ip_configuration {
      # assign public ip
      ipv4_enabled = true
      # assign private ip
      private_network = data.google_compute_network.vpc.id

      dynamic "authorized_networks" {
        for_each = var.personal_cidr_blocks
        iterator = cidr
        
        content {
          value = cidr.value
        }
      }
    }
  }
  
  deletion_protection = "false"
}

resource "google_sql_user" "webapp_user" {
  name     = var.db_username
  instance = google_sql_database_instance.webapp_instance.name
  # host = "%"
  password = var.db_password
}


# # beststories
# resource "google_sql_database" "beststories" {
#   name      = "beststories"
#   instance  = google_sql_database_instance.beststories_instance.name
#   charset   = "utf8"
#   collation = "utf8_general_ci"
# }

# resource "google_sql_database_instance" "beststories_instance" {
#   name   = "beststories-instance-${random_id.db_name_suffix.hex}"
#   region = var.region
#   database_version = "MYSQL_8_0"

#   settings {
#     tier              = var.db_tier
#     disk_size         = var.db_disk_size
#   }
  
#   deletion_protection = "false"
# }

# resource "google_sql_user" "beststories_user" {
#   name     = var.db_username
#   instance = google_sql_database_instance.beststories_instance.name
#   # host = "%"
#   password = var.db_password
# }


# # topstories
# resource "google_sql_database" "topstories" {
#   name      = "topstories"
#   instance  = google_sql_database_instance.topstories_instance.name
#   charset   = "utf8"
#   collation = "utf8_general_ci"
# }

# resource "google_sql_database_instance" "topstories_instance" {
#   name   = "topstories-instance-${random_id.db_name_suffix.hex}"
#   region = var.region
#   database_version = "MYSQL_8_0"

#   settings {
#     tier              = var.db_tier
#     disk_size         = var.db_disk_size
#   }
  
#   deletion_protection = "false"
# }

# resource "google_sql_user" "topstories_user" {
#   name     = var.db_username
#   instance = google_sql_database_instance.topstories_instance.name
#   # host = "%"
#   password = var.db_password
# }


# # newstories
# resource "google_sql_database" "newstories" {
#   name      = "newstories"
#   instance  = google_sql_database_instance.newstories_instance.name
#   charset   = "utf8"
#   collation = "utf8_general_ci"
# }

# resource "google_sql_database_instance" "newstories_instance" {
#   name   = "newstories-instance-${random_id.db_name_suffix.hex}"
#   region = var.region
#   database_version = "MYSQL_8_0"

#   settings {
#     tier              = var.db_tier
#     disk_size         = var.db_disk_size
#   }
  
#   deletion_protection = "false"
# }

# resource "google_sql_user" "newstories_user" {
#   name     = var.db_username
#   instance = google_sql_database_instance.newstories_instance.name
#   # host = "%"
#   password = var.db_password
# }


# # notifier
# resource "google_sql_database" "notifier" {
#   name      = "notifier"
#   instance  = google_sql_database_instance.notifier_instance.name
#   charset   = "utf8"
#   collation = "utf8_general_ci"
# }

# resource "google_sql_database_instance" "notifier_instance" {
#   name   = "notifier-instance-${random_id.db_name_suffix.hex}"
#   region = var.region
#   database_version = "MYSQL_8_0"

#   settings {
#     tier              = var.db_tier
#     disk_size         = var.db_disk_size
#   }
  
#   deletion_protection = "false"
# }

# resource "google_sql_user" "notifier_user" {
#   name     = var.db_username
#   instance = google_sql_database_instance.notifier_instance.name
#   # host = "%"
#   password = var.db_password
# }