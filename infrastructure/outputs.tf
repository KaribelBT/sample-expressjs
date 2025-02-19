output "project" {
  value = digitalocean_project.project.name
}
output "api" {
  value = digitalocean_app.api.name
}
output "mongodb_name" {
  value = digitalocean_database_cluster.mongodb.name
}
