terraform {
  required_version = "1.3.7"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    github = {
      source  = "integrations/github"
      version = "5.13.0"
    }

    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.4.0"
    }
  }
}

provider "local" {}

provider "github" {}

provider "bitwarden" {
  master_password = var.bw_password
  client_id       = var.bw_client_id
  client_secret   = var.bw_client_secret
  email           = var.bw_email
  server          = "https://vault.bitwarden.com"
}

# Github Actions Secret - Global - Relevant for all repos
data "bitwarden_item_login" "GOOGLE_CHAT_WEBHOOK" {
  id = "e2e02ec2-580b-4823-94bb-af70014ca324"
}

# Github Actions Secret - Global - Relevant for all repos
data "bitwarden_item_login" "GH_TOKEN_REPO_AND_PROJECT" {
  id = "7bab7564-62d2-4709-9769-af700168cfa9"
}

# Github Actions Secret - Global - Relevant for all repos
data "bitwarden_item_login" "SNYK_TOKEN" {
  id = "18d29e31-c440-4b59-9992-af7100cc6990"
}

# Github Actions Secret - Global - Relevant for all repos
data "bitwarden_item_login" "DOCKERHUB_USER" {
  id = "58479137-3c07-4592-86c2-af7100d020ba"
}
