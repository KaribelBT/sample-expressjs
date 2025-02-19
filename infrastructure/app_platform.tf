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
        deploy_on_push = true
        build_command  = "cd api && npm install && npm run build"
        run_command    = "cd api && npm start"
      }

      log_destination {
        name = "sample-expressjs"
        papertrail {
          endpoint = var.PAPERTRAIL_ENDPOINT
        }
      }
    }
  }
}
