#!/usr/bin/env bats

@test "major-env: with lab" {
  result=$(bash ./actions/iaas-major-env/script.sh lab)
  [ "$result" == "lab" ]
}

@test "major-env: with dev" {
  result=$(bash ./actions/iaas-major-env/script.sh dev)
  [ "$result" == "dev" ]
}

@test "major-env: with test" {
  result=$(bash ./actions/iaas-major-env/script.sh test)
  [ "$result" == "test" ]
}

@test "major-env: with perf" {
  result=$(bash ./actions/iaas-major-env/script.sh perf)
  [ "$result" == "test" ]
}

@test "major-env: with prod" {
  result=$(bash ./actions/iaas-major-env/script.sh prod)
  [ "$result" == "prod" ]
}

@test "major-env: with foobar" {
  result=$(bash ./actions/iaas-major-env/script.sh foobar)
  [ "$result" == "test" ]
}

@test "major-env: with no inputs" {
  run ./actions/iaas-major-env/script.sh
  [ "$status" == 99 ]
}
