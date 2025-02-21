# Documentation: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project_resources
# Resources must be created and then related to the project

data "digitalocean_project" "project" {
  name = var.PROJECT_NAME
}

resource "digitalocean_project_resources" "project_resources" {
  project = data.digitalocean_project.project.id

  resources = [
    digitalocean_database_cluster.mongodb.urn,
    digitalocean_app.api.urn
  ]
}
