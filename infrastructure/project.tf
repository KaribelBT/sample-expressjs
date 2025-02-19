resource "digitalocean_project" "project" {
  name        = "kbt-tftest-project"
  description = "A project to test terraform deploys for KBT."
  purpose     = "Development"
  environment = var.ENV
}
