# Repository
# https://github.com/sebastian-sommerfeld-io/trashbox

data "github_repository" "trashbox" {
  full_name = "sebastian-sommerfeld-io/trashbox"
}

resource "github_actions_secret" "trashbox_example" {
  repository      = data.github_repository.trashbox.id
  secret_name     = "EXAMPLE_FROM_TERRAFORM"
  plaintext_value = "demo"
}
