output "project" {
  value = digitalocean_project.project.name
}
output "api_live_url" {
  value = digitalocean_app.api.live_url
}
output "mongodb_name" {
  value = digitalocean_database_cluster.mongodb.name
}
