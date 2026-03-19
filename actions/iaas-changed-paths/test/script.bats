#!/usr/bin/env bats

@test "iaas-changed-paths: with two files in same directory and max_depth 5" {
  files_json_string="[\"io/travelport/dev/awsuse1/nggf-00/workspace_ec2_splash_deployment.tf\","
  files_json_string+="\"io/travelport/dev/awsuse1/nggf-00/workspace_asg_xpm_deployment.tf\"]"
  result=$(bash ./actions/iaas-changed-paths/script.sh --max_depth 5 --files_json_string "${files_json_string}")
  [ "$result" == "[\"io/travelport/dev/awsuse1/nggf-00\"]" ]
}

@test "iaas-changed-paths: with two files in different directories and max_depth 0" {
  files_json_string="[\"io/travelport/dev/awsuse1/nggf-00/nested/some_file.txt\","
  files_json_string+="\"io/travelport/dev/awsuse1/nggf-11/nested/some_file.txt\"]"
  result=$(bash ./actions/iaas-changed-paths/script.sh --max_depth 0 --files_json_string "${files_json_string}")
  echo "$result"
  [ "$result" == "[\"io/travelport/dev/awsuse1/nggf-00/nested\",\"io/travelport/dev/awsuse1/nggf-11/nested\"]" ]
}

@test "iaas-changed-paths: error missing --files_json_string and exit with 1" {
  run ./actions/iaas-changed-paths/script.sh --max_depth 5
  [ "$status" -eq 1 ]
  [ "$output" == "ERROR: Missing required parameter: --files_json_string <files_json_string>" ]
}

@test "iaas-changed-paths: error missing --max_depth and exit with 1" {
  files_json_string="[\"io/travelport/dev/awsuse1/nggf-00/workspace_ec2_splash_deployment.tf\","
  files_json_string+="\"io/travelport/dev/awsuse1/nggf-00/workspace_asg_xpm_deployment.tf\"]"
  run ./actions/iaas-changed-paths/script.sh --files_json_string "${files_json_string}"
  [ "$status" -eq 1 ]
  [ "$output" == "ERROR: Missing required parameter: --max_depth <integer>" ]
}

@test "iaas-changed-paths: error unknown parameter and exit with 1" {
  run ./actions/iaas-changed-paths/script.sh --foo blue
  [ "$status" -eq 1 ]
  [ "$output" == "ERROR: Unknown parameter --foo" ]
}

@test "iaas-changed-paths: error no required parameters and exit with 1" {
  run ./actions/iaas-changed-paths/script.sh
  [ "$status" -eq 1 ]
  [ "$output" == "ERROR: Missing required parameter: --max_depth <integer> --files_json_string <files_json_string>" ]
}
