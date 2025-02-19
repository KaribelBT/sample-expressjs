resource "digitalocean_app" "sample_expressjs" {
  spec {
    name   = "sample-expressjs"
    region = "nyc"

    service {
      name               = "sample-expressjs"
      environment_slug   = "node-js"
      instance_count     = 1
      instance_size_slug = "basic-xxs"

      git {
        repo_clone_url = "https://github.com/KaribelBT/sample-expressjs.git"
        branch         = "main"
      }
      github {
        deploy_on_push = true
      }

      source_dir = "api"

      log_destination {
        name = "sample-expressjs"
        papertrail {
          endpoint = var.PAPERTRAIL_ENDPOINT
        }
      }
    }
  }
}
