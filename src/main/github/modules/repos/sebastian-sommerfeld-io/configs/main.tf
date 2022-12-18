# Repository
# https://github.com/sebastian-sommerfeld-io/configs

data "github_repository" "configs" {
  full_name = "sebastian-sommerfeld-io/configs"
}

module "configs-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.configs.id
}