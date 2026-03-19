#!/usr/bin/env bash

OUTPUT=""

declare -a POSITIONAL_ARGS=()

function validate_params() {
  if [[ -z "${FILES_JSON_STRING}" || -z "${MAX_DEPTH}" ]] ; then
    OUTPUT="ERROR: Missing required parameter:"
    if [ -z "${MAX_DEPTH}" ]; then
      OUTPUT+=" --max_depth <integer>"
    fi
    if [ -z "${FILES_JSON_STRING}" ]; then
      OUTPUT+=" --files_json_string <files_json_string>"
    fi
    return 1
  fi
  return 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--files_json_string)
      FILES_JSON_STRING="$2"
      shift # past argument
      shift # past value
      ;;
    -m|--max_depth)
      MAX_DEPTH="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
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

if ! validate_params;  then
  echo "$OUTPUT"
  exit 1
fi

pathsArray=()

len=$(echo "$FILES_JSON_STRING" | jq length)
for index in $( seq 0 $((len - 1)) ); do
  path=""
  file=$(echo "$FILES_JSON_STRING" | jq .[$index] | cut -d '"' -f2)
  if [ "${MAX_DEPTH}" -gt 0 ] ; then
    for (( depth=1; depth<="${MAX_DEPTH}"; depth++ )); do
      path+=$(echo "${file}" | cut -d "/" -f"${depth}")
      [[ "$depth" -lt "${MAX_DEPTH}" ]] && path+="/"
    done
  else
    path=$(dirname "$file")
  fi
  pathsArray+=("${path}")
done
pathsArray=($(printf "%s\n" "${pathsArray[@]}" | sort -u))

result="["
lastIndex=$(( ${#pathsArray[@]} - 1 ))
for index in "${!pathsArray[@]}"; do
  result+="\"${pathsArray[$index]}\""
  [ "$index" -eq "$lastIndex" ] || result+=","
done
result+="]"
echo "$result"

exit 0
