resource "digitalocean_project" "project" {
  name        = "kbt-tftest-project"
  description = "A project to test terraform deploys for KBT."
  purpose     = "Development"
  environment = var.ENV
}

resource "digitalocean_project_resources" "project_resources" {
  project = digitalocean_project.project.id

  resources = [
    digitalocean_database_cluster.mongodb.id,
    digitalocean_app.api.id
  ]
}
