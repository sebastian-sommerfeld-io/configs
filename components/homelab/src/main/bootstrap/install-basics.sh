#!/bin/bash
# @file basics.sh
# @brief Run basic provisioning.
#
# @description This script runs the basic provisioning. This is a prerequisite to run the ansible steps.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# curl https://raw.githubusercontent.com/sebastian-sommerfeld-io/configs/main/components/homelab/src/main/bootstrap/basics.sh | bash -
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly LOG_DONE="[\e[32mDONE\e[0m]"
# readonly LOG_ERROR="[\e[1;31mERROR\e[0m]"
readonly LOG_INFO="[\e[34mINFO\e[0m]"
# readonly LOG_WARN="[\e[93mWARN\e[0m]"
readonly Y="\e[93m"
readonly P="\e[35m"
readonly D="\e[0m"


echo -e "$LOG_INFO +---------------------------------------------------+"
echo -e "$LOG_INFO |    Install basic tools and apply basic configs    |"
echo -e "$LOG_INFO |    to allow further setup using Ansible.          |"
echo -e "$LOG_INFO +---------------------------------------------------+"
echo -e "$LOG_INFO Running on host ${P}$HOSTNAME${D}"


echo -e "$LOG_INFO ${Y}Update apt cache${D}"
sudo apt-get -y update

echo -e "$LOG_INFO ${Y}Install basics${D}"
sudo apt-get install -y ca-certificates
sudo apt-get install -y curl
sudo apt-get install -y gnupg
sudo apt-get install -y lsb-release

echo -e "$LOG_INFO ${Y}Install git${D}"
sudo apt-get install -y git

echo -e "$LOG_INFO ${Y}Install docker${D}"
echo -e "$LOG_INFO Uninstall old docker versions"
sudo apt-get remove -y docker docker-engine docker.io containerd runc
echo -e "$LOG_INFO Install docker using the convenience script"
curl -fsSL https://get.docker.com | sudo bash -
echo -e "$LOG_DONE Installed docker"
echo -e "$LOG_DONE Installed docker"
