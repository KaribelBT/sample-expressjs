Documentation: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project_resources
Resources must be created and then related to the project
resource "digitalocean_project_resources" "project_resources" {
  project = digitalocean_project.project.id

  resources = [
    digitalocean_database_cluster.mongodb.urn,
    digitalocean_app.api.urn
  ]
}
