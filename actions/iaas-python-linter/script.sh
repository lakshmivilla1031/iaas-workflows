#!/usr/bin/env bash

file_params="$*"
rc=0

if [ "$#" -eq 0 ] ; then
  echo "ERROR:, script.sh, line 7, At least one file is required"
  exit 99
fi

echo "-----------PYLINT---------------------"
echo "PyLint running, we are checking the following list: \"$file_params\" "
echo "Documentation: https://docs.pylint.org"
pylint -j 0 --output-format=text $file_params || rc=$?
if [ "$rc" -eq 0 ]; then
  echo "INFO:, script.sh, line 14, pylint return code 0, (0 if no errors or warning messages occur)"
elif [ "$rc" -eq 1 ]; then
  echo "FATAL:, script.sh, line 14, pylint return code 1, (1 if one or more fatal messages occur)"
elif [ "$rc" -lt 32 ]; then
  echo "ALERT:, script.sh, line 14, pylint return code $rc, ($rc if one or more error/warn messages occur)"
else
  echo "FATAL:, script.sh, line 14, pylint return code, not caught/expected, return code: $rc"
fi
exit "$rc"