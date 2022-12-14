# Repository
# https://github.com/sebastian-sommerfeld-io/github-action-generate-readme

data "github_repository" "github-action-generate-readme" {
  full_name = "sebastian-sommerfeld-io/github-action-generate-readme"
}

module "github-action-generate-readme-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.github-action-generate-readme.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}

resource "github_actions_secret" "github-action-generate-readme_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.github-action-generate-readme.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "github-action-generate-readme_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.github-action-generate-readme.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
