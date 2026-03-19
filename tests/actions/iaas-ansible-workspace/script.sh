#!/usr/bin/env bash

inventory_path="$1"
limit="$2"

if [ -z "${inventory_path}" ] ; then
  echo "ERROR:, script.sh, line 5, Required inventory_path parameter is not set"
  exit 1
fi

if [ ! -e "${inventory_path}" ] ; then
  echo "ERROR:, script.sh, line 10, Provided inventory_path '${inventory_path}' does not exist"
  exit 1
fi

workspace=$(pwd)

date +%Y%m%d-%H%M%S
export WORKSPACE="${workspace}"
export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_STDOUT_CALLBACK=debug
export ANSIBLE_LIBRARY=Pipelines/modules

playbook="Pipelines/playbooks/util/ValidateLimits.yml"
limit=("--limit" "${limit}")

echo "ansible-playbook -f9 --vault-password=~/.vp -i ${inventory_path} ${playbook} ${limit[0]} ${limit[1]}"
# shellcheck disable=SC2086
# shellcheck disable=SC2090
ansible-playbook -f9 --vault-password=~/.vp -i ${inventory_path} ${playbook} ${limit[0]} ${limit[1]}

exit "$?"