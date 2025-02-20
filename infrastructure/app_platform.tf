# Documentation: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/app
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
      # DigitalOcean does not have a direct equivalent to Key Vault for secrets management. HashiCorp Vault can be a paid alternative
      env {
        key   = "MONGODB_CONNECTION_STRING"
        value = "mongodb+srv://${digitalocean_database_cluster.mongodb.user}:${digitalocean_database_cluster.mongodb.password}@${digitalocean_database_cluster.mongodb.host}/admin"
        scope = "RUN_AND_BUILD_TIME"
        type  = "SECRET"
      }
      env {
        key   = "MONGODB_DB_NAME"
        value = digitalocean_database_cluster.mongodb.name
        scope = "RUN_AND_BUILD_TIME"
        type  = "GENERAL"
      }
      env {
        key   = "MONGODB_COLLECTION_NAME"
        value = var.MONGODB_COLLECTION_NAME
        scope = "RUN_AND_BUILD_TIME"
        type  = "GENERAL"
      }
      # Documentation: https://docs.digitalocean.com/products/app-platform/how-to/forward-logs/
      # Only basic logs are available in App Platform, alternative is to forward application runtime logs to external log management providers.
      log_destination {
        name = "kbt-tftest-api"
        papertrail {
          endpoint = var.PAPERTRAIL_ENDPOINT
        }
      }
    }
  }
}
