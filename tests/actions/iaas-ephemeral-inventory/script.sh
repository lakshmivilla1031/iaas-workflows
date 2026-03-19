#!/usr/bin/env bash

deployment_path="${1}"

if [ -z "${deployment_path}" ] ; then
  echo "ERROR:, script.sh, line 5, Required deployment_path parameter is not set"
  exit 1
fi

if [ ! -e "${deployment_path}" ] ; then
  echo "ERROR:, script.sh, line 10, Provided deployment_path '${deployment_path}' does not exist"
  exit 1
fi

workspace=$(pwd)

export WORKSPACE="${workspace}"
export ANSIBLE_STDOUT_CALLBACK=debug
export ANSIBLE_LIBRARY=Pipelines/modules
export ANSIBLE_FORCE_COLOR=true

date +%Y%m%d-%H%M%S
if ! ansible-inventory -v --vault-password=~/.vp -i "${deployment_path}" --graph ; then
  echo "ERROR:, script.sh, line 22, UNABLE to parse inventory...probably invalid YAML"
  exit "$?"
fi
