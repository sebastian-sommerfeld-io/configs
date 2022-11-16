#!/bin/bash
# @file yamllint.sh
# @brief Wrapper to use yamllint from Docker container when using the default ``yamllint`` command.
#
# @description The script is a wrapper to use yamllint from a Docker container when using the default ``yamllint``
# command. The script delegates the all tasks to the yamllint runtime inside a container using image
# link:https://hub.docker.com/r/cytopia/yamllint[cytopia/yamllint].
#
# In order to use the ``yamllint`` command the symlink ``/usr/bin/yamllint`` is added.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# === Script Arguments
#
# * *$@* (array): Original arguments
#
# === Script Example
#
# ```
# yamllint .
# ```


IMAGE="cytopia/yamllint"
TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished yamllint"
