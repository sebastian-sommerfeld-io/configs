#!/bin/bash
# @file minikube-cli.sh
# @brief Script to manage minikube.
#
# @description This script controls the local minikube instance. It allows to start, stop and expose the dashboard.
# Common commands are available as options. The script is interactive and will prompt the user to select an action.
# More specific actions need to be executed directly with minikube.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./minikube-cli.sh
# ```
#
# == Prerequisites
#
# A locla Docker and a local miniKube installation is required.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly OPTION_START="start"
readonly OPTION_STOP="stop"
readonly OPTION_DASHBOARD="dashboard"
readonly OPTION_HELP="help"
readonly OPTION_PODS="list-pods"


# @description Utility function to startup minikube.
function startup() {
  echo -e "$LOG_INFO Startup minikube on ${P}${HOSTNAME}${D}"
  minikube start
}


# @description Utility function to shutdown minikube.
function shutdown() {
  echo -e "$LOG_INFO Shutdown minikube on ${P}${HOSTNAME}${D}"
  minikube stop
}


# @description Utility function to expose the minikube dashboad.
function dashboard() {
  echo -e "$LOG_INFO Expose the minikube dashboard"
  minikube dashboard
}


# @description Utility function to expose the minikube dashboad.
function pods() {
  echo -e "$LOG_INFO List pods from all namespaces"
  minikube kubectl -- get po -A
}


# @description Utility function to display the minikube help.
function help() {
  echo -e "$LOG_INFO minikube help"
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  echo -e "$LOG_WARN Remember to use minikube directly when invoking commands that are not supported by this script"
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  minikube
}


echo -e "$LOG_INFO Select the action"
select s in "$OPTION_START" "$OPTION_STOP" "$OPTION_DASHBOARD" "$OPTION_PODS" "$OPTION_HELP"; do
    case "$s" in
    "$OPTION_START" )
        startup
        break;;
    "$OPTION_STOP" )
        shutdown
        break;;
    "$OPTION_DASHBOARD" )
        dashboard
        break;;
    "$OPTION_PODS" )
        pods
        break;;
    "$OPTION_HELP" )
        help
        break;;
    esac
done
