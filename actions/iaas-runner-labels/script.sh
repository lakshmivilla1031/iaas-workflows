#!/usr/bin/env bash

while [[ $# -gt 0 ]]; do
  case $1 in
    -r|--region)
      _REGION="$2"
      shift # past argument
      shift # past value
      ;;
    -e|--env)
      _ENV="$2"
      shift # past argument
      shift # past value
      ;;
    -*)
      echo "ERROR: Unknown parameter $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

output="[\"self-hosted\","

_loc="onprem"
_type="toolkit"

if [[ "${_REGION}" == aws* ]] ; then
  if [ -z "${_ENV}" ] ; then
    _loc="aws-eks"
    _type="toolkit-runner"
  else
    _loc="aws"
    output+="\"${_ENV}\","
  fi
  output+="\"${_loc}\","
  output+="\"${_type}\""
else
  output+="\"${_ENV}\","
  output+="\"${_loc}\","
  output+="\"${_type}\""
fi
output+="]"

echo "$output"
echo "value=${output}" >> "$GITHUB_OUTPUT"
#
exit 0