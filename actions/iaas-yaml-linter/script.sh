#!/usr/bin/env bash

file_params="$*"
rc=0

if [ "$#" -eq 0 ] ; then
  echo "ERROR:, script.sh, line 7, At least one file is required"
  exit 99
fi

echo "-----------YAMLLINT---------------------"
echo "YamlLint running, we are checking the following list: \"$file_params\""
echo "Documentation: https://www.mankier.com/1/yamllint"
yamllint --strict $file_params || rc=$?
if [ $rc -eq 0 ]; then
  echo "INFO:, script.sh, line 14, yamllint return code 0, (0 if no errors or warnings occur)"
elif [ $rc -eq 1 ]; then
  echo "ERROR:, script.sh, line 14, yamllint return code 1, (1 if one or more errors occur)"
elif [ $rc -eq 2 ]; then
  echo "ERROR:, script.sh, line 14, yamllint return code 2, (2 if no errors occur, but one or more warnings occur)"
else
  echo "ERROR:, script.sh, line 14, yamllint return code, not caught/expected, return code: $rc"
fi

if [ $rc -eq 0 ] || [ $rc -eq 2 ]; then
  exit 0
else
  exit $rc
fi
