# Documentation: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_cluster
resource "digitalocean_database_cluster" "mongodb" {
  name       = "kbt-tftest-mongodb"
  engine     = "mongodb"
  version    = "7"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
}

# Documentation: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_mongodb_config
# Trusted sources to link the database to an app platform is not supported by terraform nor DO API
resource "digitalocean_database_mongodb_config" "mongodb_config" {
  cluster_id                         = digitalocean_database_cluster.mongodb.id
  default_read_concern               = "majority"
  default_write_concern              = "majority"
  transaction_lifetime_limit_seconds = 100
  slow_op_threshold_ms               = 100
  verbosity                          = 3
}
