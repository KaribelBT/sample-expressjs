resource "digitalocean_app" "api" {
  spec {
    name   = "kbt-tftest-project"
    region = "nyc"

    service {
      name               = "kbt-tftest-project"
      environment_slug   = "node-js"
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      git {
        repo_clone_url = "https://github.com/${var.API_REPO}.git"
        branch         = "main"
      }
      github {
        deploy_on_push = true
        repo           = var.API_REPO
        branch         = "main"

      }
      source_dir = "api"
      log_destination {
        name = "kbt-tftest-project"
        papertrail {
          endpoint = var.PAPERTRAIL_ENDPOINT
        }
      }
    }
  }
}
