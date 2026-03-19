#!/usr/bin/env bash

while [[ $# -gt 0 ]]; do
  case $1 in
    -w|--workspace)
      WORKSPACE="$2"
      shift # past argument
      shift # past value
      ;;
    -u| --user)
      USER="$2"
      shift # past argument
      shift # past value
      ;;
    -e| --email)
      EMAIL="$2"
      shift # past argument
      shift # past value
      ;;
    -t| --token)
      TOKEN="$2"
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

pushd "${WORKSPACE}" || exit

if [ ! -e "$HOME/.git-credentials" ] ; then
  echo "https://${GITHUB_ACTOR}:${TOKEN}@github.com" > "${HOME}"/.git-credentials
fi

git config credential.username "${GITHUB_ACTOR}"
git config --local user.email "${EMAIL}"
git config --local user.name "${USER}"
git config push.default simple
git config pull.rebase true   # rebase
git config credential.helper store

exit 0