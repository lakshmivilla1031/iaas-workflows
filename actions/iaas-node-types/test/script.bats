#!/usr/bin/env bats

@test "format-node-types: with single node type" {
  result=$(bash ./actions/iaas-node-types/script.sh foo)
  [ "$result" == "[\"foo\"]" ]
}

@test "format-node-types: with two node types" {
  result=$(bash ./actions/iaas-node-types/script.sh foo bar)
  [ "$result" == "[\"foo\",\"bar\"]" ]
}

@test "format-node-types: error zero node types and exit with 1" {
  run ./actions/iaas-node-types/script.sh
  [ "$status" -eq 1 ]
}
