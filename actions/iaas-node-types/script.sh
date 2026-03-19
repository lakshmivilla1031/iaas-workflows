#!/usr/bin/env bash

[ $# -eq 0 ] && exit 1

nodeTypesArray=($@)
output="["
lastIndex=$((${#nodeTypesArray[@]} - 1))
for index in "${!nodeTypesArray[@]}"; do
  output+="\"${nodeTypesArray[$index]}\""
  [ "$index" -eq "$lastIndex" ] || output+=","
done
output+="]"
echo "$output"
echo "value=${output}" >> "$GITHUB_OUTPUT"
#
exit 0