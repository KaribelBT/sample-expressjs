output "project_id" {
  value = data.digitalocean_project.project.id
}
output "api_live_url" {
  value = digitalocean_app.api.live_url
}
output "mongodb_name" {
  value = digitalocean_database_cluster.mongodb.name
}
