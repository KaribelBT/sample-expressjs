resource "digitalocean_app" "api" {
  spec {
    name   = "kbt-tftest-api"
    region = "nyc"

    service {
      name               = "kbt-tftest-api"
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
      env {
        key   = "MONGODB_CONNECTION_STRING"
        value = "mongodb+srv://${digitalocean_database_cluster.mongodb.user}:${digitalocean_database_cluster.mongodb.password}@${digitalocean_database_cluster.mongodb.host}/admin"
        scope = "RUN_AND_BUILD_TIME"
        type  = "SECRET"
      }
      env {
        key   = "MONGODB_COLLECTION_NAME"
        value = var.MONGODB_COLLECTION_NAME
        scope = "RUN_AND_BUILD_TIME"
        type  = "GENERAL"
      }
      log_destination {
        name = "kbt-tftest-api"
        papertrail {
          endpoint = var.PAPERTRAIL_ENDPOINT
        }
      }
    }
  }
}
