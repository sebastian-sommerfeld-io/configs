#!/bin/bash
# @file ansible-cli.sh
# @brief Command line interface to run Ansible playbooks.
#
# @description This script runs the Ansible playbooks. Ansible runs in Docker.
#
# Make sure to run ``ssh-copy-id <REMOTE_USER>@<REMOTE_SERVER>.fritz.box`` for all relevant machines.
#
# NOTE: Ansible expects the user ``sebastian`` to be present on all nodes. This user is the default
# user for each node (workstation and RasPi). Normally this user is created from the setup wizard.
# This scripts exits with ``exitcode=8`` if this user does not exist.
#
# [source, bash]
# ----
# ssh-copy-id sebastian@caprica.fritz.box
# ssh-copy-id sebastian@kobol.fritz.box
# ssh-copy-id pi@prometheus.fritz.box
# ----
#
# ==== Arguments
#
# The script does not accept any parameters.


MANDATORY_USER="sebastian"

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# @description Wrapper function to encapsulate link:https://hub.docker.com/r/cytopia/ansible[ansible in a docker container].
# The current working directory is mounted into the container and selected as working directory so that all file are
# available to ansible. Paths are preserved.
#
# @example
#    echo "test: $(invoke ansible --version)"
#
# @arg $@ String The ansible commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with ansible command is missing
function invoke() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command passed to the ansible container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi

  docker run -it --rm \
    --volume "$HOME/.ssh:/root/.ssh:ro" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    --network host \
    cytopia/ansible:latest-tools "$@"
}


# @description Facade to map ``ansible`` command.
#
# @example
#    echo "test: $(ansible --version)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible() {
  invoke ansible "$@"
}


# @description Facade to map ``ansible-playbook`` command.
#
# @example
#    echo "test: $(ansible-playbook playbook.yml)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible-playbook() {
  invoke ansible-playbook "$@"
}


docker run --rm mwendler/figlet:latest 'Ansible CLI'
(
  cd ansible || exit

  if ! id "$MANDATORY_USER" &>/dev/null; then
    echo -e "$LOG_ERROR +-----------------------------------------------------------------------------+"
    echo -e "$LOG_ERROR |    MANDATORY USER NOT FOUND !!!                                             |"
    echo -e "$LOG_ERROR |                                                                             |"
    echo -e "$LOG_ERROR |    Ansible expects the user ${P}sebastian${D} to be present on all nodes.           |"
    echo -e "$LOG_ERROR |    This user is the default user for each node (workstation and RasPi).     |"
    echo -e "$LOG_ERROR |    Normally this user is created from the setup wizard.                     |"
    echo -e "$LOG_ERROR +-----------------------------------------------------------------------------+"
    echo -e "$LOG_ERROR exit" && exit 8
  fi


  echo -e "$LOG_INFO Select playbook"
  #select s in $(cd playbooks && ls | grep .yml | grep -v playbook); do
  select playbook in playbooks/*.yml; do
    echo -e "$LOG_INFO Run $P$playbook$D"
    ansible-playbook "$playbook" --inventory hosts.yml --ask-become-pass

    break
  done
)
