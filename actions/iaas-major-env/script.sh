#!/usr/bin/env bash

if [ "$#" -ne 1 ] ; then
  echo "ERROR:, script.sh, line 3, environment parameter is required"
  exit 99
fi

input="$1"

major_env=''
case "${input}" in
  tools)
    major_env='tools'
    ;;
  dev)
    major_env='dev'
    ;;
  iaastest)
    major_env='dev'
    ;;
  lab)
    major_env='lab'
    ;;
  dv)
    major_env='dev'
    ;;
  dvdev)
    major_env='dev'
    ;;
  prod)
    major_env='prod'
    ;;
  deltadr)
    major_env='prod'
    ;;
  *)
    # anything else is some kind of test environment!  perf, perf1, qa, uat, nonprod, pp, etc.
    major_env='test'
    ;;
esac
echo $major_env

exit 0