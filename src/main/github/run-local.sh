#!/bin/bash
# @file run-local.sh
# @brief Wrapper script to apply the Github configuration during development from localhost in an
# easier way.
#
# @description This script is just a wrapper script to apply the Github configuration during
# development from localhost in an easier way. It provides a menu to select the action of choise and
# delegates all commands to `xref:AUTO-GENERATED:bash-docs/src/main/github/apply-config-sh.adoc[apply-config.sh]`.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./run-local.sh
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


TOKEN="$(cat .secrets/github.token)"
readonly TOKEN

BW_CLIENT_ID="$(cat .secrets/BW_CLIENT_ID.secret)"
readonly BW_CLIENT_ID
BW_CLIENT_SECRET="$(cat .secrets/BW_CLIENT_SECRET.secret)"
readonly BW_CLIENT_SECRET
BW_MASTER_PASS="$(cat .secrets/BW_MASTER_PASS.secret)"
readonly BW_MASTER_PASS

readonly OPTION_CLEAN="clean_local_filesystem"
readonly OPTION_INIT="terraform_init"
readonly OPTION_PLAN="terraform_plan"
readonly OPTION_APPLY="terraform_apply"


echo -e "$LOG_INFO Apply Github configuration"
echo -e "$LOG_INFO ${Y}What do you want me to do?${D}"
select task in "$OPTION_CLEAN" "$OPTION_INIT" "$OPTION_PLAN" "$OPTION_APPLY"; do
  case "$task" in
    "$OPTION_CLEAN" )
        rm -rf .terraform*
        rm -rf terraform*
    ;;
    "$OPTION_INIT" )
        bash ./apply-config.sh init "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
    ;;
    "$OPTION_PLAN" )
        bash ./apply-config.sh lint "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
        bash ./apply-config.sh validate "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
        bash ./apply-config.sh fmt "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
        bash ./apply-config.sh plan "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
    ;;
    "$OPTION_APPLY" )
        bash ./apply-config.sh apply "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
    ;;
  esac

  break
done
