#!/bin/bash
# @file bootstrap.sh
# @brief Run basic provisioning.
#
# @description This script runs the basic provisioning. This is a prerequisite to run the ansible steps.
#
# ==== Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


LOG_DONE="[\e[32mDONE\e[0m]"
# LOG_ERROR="[\e[1;31mERROR\e[0m]"
LOG_INFO="[\e[34mINFO\e[0m]"
# LOG_WARN="[\e[93mWARN\e[0m]"
Y="\e[93m"
P="\e[35m"
D="\e[0m"


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


echo -e "$LOG_INFO ${Y}Install openssh-server${D}"
echo -e "$LOG_INFO Install and start SSH server"
sudo apt-get -y update
sudo apt-get install -y openssh-server
sudo ufw allow ssh # if the firewall is enabled on your system, open the ssh port
sudo systemctl enable --now ssh
echo -e "$LOG_DONE Installed and started SSH server"


echo -e "$LOG_INFO ${Y}Install docker${D}"
echo -e "$LOG_INFO Uninstall old docker versions"
sudo apt-get remove -y docker docker-engine docker.io containerd runc

echo -e "$LOG_INFO Install docker using the convenience script"
curl -fsSL https://get.docker.com | sudo bash -
echo -e "$LOG_DONE Installed docker"

echo -e "$LOG_DONE Installed docker"
