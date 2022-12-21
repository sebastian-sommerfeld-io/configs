# Repository
# https://github.com/sebastian-sommerfeld-io/github-action-update-antora-yml

data "github_repository" "github-action-update-antora-yml" {
  full_name = "sebastian-sommerfeld-io/github-action-update-antora-yml"
}

module "github-action-update-antora-yml-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.github-action-update-antora-yml.id
}

resource "github_actions_secret" "github-action-update-antora-yml_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.github-action-update-antora-yml.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "github-action-update-antora-yml_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.github-action-update-antora-yml.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
