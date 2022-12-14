#!/bin/bash
# @file groovy.sh
# @brief Wrapper to use Groovy from Docker container when using the default ``groovy`` command.
#
# @description The script is a wrapper to use Groovy from a Docker container when using the default ``groovy`` command.
# The script delegates the all tasks to the Groovy runtime inside a container using image
# link:https://hub.docker.com/_/groovy[groovy].
#
# In order to use the ``groovy`` command the symlink ``/usr/bin/groovy`` is added.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/homelab/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# === Script Arguments
#
# * *$@* (array): Original arguments


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="groovy"
readonly TAG="4.0.0-jdk17"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" groovy "$@"
