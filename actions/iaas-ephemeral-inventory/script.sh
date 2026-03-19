#!/usr/bin/env bash

deployment_path="$1"
node_types=$(echo "$2" | base64 --decode)

buildEphemeralInventory() {
  local file="$1"
  date +%Y%m%d-%H%M%S
  echo $file
  if ! ansible-inventory -v --vault-password=~/.vp -i "${file}" --graph ; then
    echo "ERROR:, script.sh, line 10, UNABLE to parse inventory...probably invalid YAML"
    exit "$?"
  fi
  if ! ansible-playbook --vault-password=~/.vp -i "$file" AnsibleInventories/buildInventory.yml; then
    echo "ERROR:, script.sh, line 14, UNABLE to build inventory...check Ansible output"
    exit "$?"
  fi
}

if [ -z "${deployment_path}" ] ; then
  echo "ERROR:, script.sh, line 5, Required deployment_path parameter is not set"
  exit 1
fi

if [ ! -e "${deployment_path}" ] ; then
  echo "ERROR:, script.sh, line 10, Provided deployment_path '${deployment_path}' does not exist"
  exit 1
fi

var_path="${deployment_path}"
if [[ -f "${var_path}" ]] ; then
  var_path=$(dirname "${deployment_path}")
fi
namespace=$(basename "${var_path}")

workspace=$(pwd)

export WORKSPACE="${workspace}"
export INVENTORY_STAMP="${namespace}"
export ANSIBLE_STDOUT_CALLBACK=debug
export ANSIBLE_LIBRARY=Pipelines/modules
export ANSIBLE_FORCE_COLOR=true

if [[ -f "${deployment_path}" ]] ; then
  filename=$(basename "${deployment_path}")
  buildEphemeralInventory "${deployment_path}"
  echo "value=AnsibleInventories/ephemeral_inventory-${namespace}/${filename}" >> "${GITHUB_OUTPUT}"
else
  if [ -n "$node_types" ] ; then
    for node in $node_types ; do
      buildEphemeralInventory "${deployment_path}/${node}.yml"
    done
  else
    for file in "${deployment_path}"/*.yml ; do
      buildEphemeralInventory "${file}"
    done
  fi
  echo "value=AnsibleInventories/ephemeral_inventory-${namespace}/" >> "${GITHUB_OUTPUT}"
fi

exit 0