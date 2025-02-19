resource "digitalocean_database_cluster" "mongodb" {
  name       = "kbt-tftest-mongodb"
  engine     = "mongodb"
  version    = "4"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  node_count = 1

  maintenance_window {
    day  = "saturday"
    hour = 3
  }
}
