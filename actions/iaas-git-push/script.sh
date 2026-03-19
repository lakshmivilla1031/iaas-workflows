#!/usr/bin/env bash

while [[ $# -gt 0 ]]; do
  case $1 in
    -w|--workspace)
      WORKSPACE="$2"
      shift # past argument
      shift # past value
      ;;
    -c| --commit_message)
      COMMIT_MESSAGE=$(echo "$2" | base64 --decode)
      shift # past argument
      shift # past value
      ;;
    -d| --destination_branch)
      DESTINATION_BRANCH="$2"
      shift # past argument
      shift # past value
      ;;
    -fp| --file_patterns)
      FILE_PATTERNS=$(echo "$2" | base64 --decode)
      shift # past argument
      shift # past value
      ;;
    --allow-empty)
      EMPTY="--allow-empty"
      shift # past argument
      ;;
    --force)
      FORCE="--force"
      shift # past argument
      ;;
    --tags)
      TAGS="--tags"
      shift # past argument
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

if [ -z "${DESTINATION_BRANCH}" ] ; then
  echo destination_branch was not set... will attempt to push to whatever was already checked out
else
  git branch --set-upstream-to=origin/"${DESTINATION_BRANCH}" "${DESTINATION_BRANCH}"
fi

[[ $(git status --porcelain) ]] && RC=0 || RC=1
if [ "$RC" -eq 0 ] ; then
  echo "differences detected in ${COMMIT_MESSAGE}, commit+push to git..."
  # figure out filename that changed, notification will use it
  git diff --summary HEAD .
  echo "________________________________________________"
  echo " commit"
  commit_message="${COMMIT_MESSAGE} change $(date +%Y%m%d-%H%M%S)"
  commit_message+="run_id ${GITHUB_RUN_ID} job ${GITHUB_JOB}."
  for pattern in ${FILE_PATTERNS}; do
    # shellcheck disable=SC2086
    git add ./${pattern} --all -v
  done
  git commit -m "${COMMIT_MESSAGE}"
  git fetch origin "${DESTINATION_BRANCH}"
  if ! git pull origin "${DESTINATION_BRANCH}"; then
    echo "FATAL: failure during pull...aborting"
    echo "value=$?" >> "$GITHUB_OUTPUT"
    exit $?
  fi
  echo " finally, push to git..."
  if ! git push --verbose --follow-tags $FORCE $TAGS $EMPTY ; then
    echo "FATAL: failure during gitpush of ${COMMIT_MESSAGE}, return code $PUSH_RETURN"
    echo "value=5" >> "$GITHUB_OUTPUT"
    exit 5
  else
    echo "SUCCESS: iaas-git-push committed and pushed ${COMMIT_MESSAGE}"
    echo "value=0" >> "$GITHUB_OUTPUT"
    exit 0
  fi
elif [ "$RC" -eq 1 ] ; then
  echo "Exiting..nothing to commit"
  echo "value=1" >> "$GITHUB_OUTPUT"
  exit 0
else
  echo "ABORTING: something strange happened to git diff, return code was $RET"
  echo "value=6" >> "$GITHUB_OUTPUT"
  exit 6
fi

popd || exit
exit 0