#!/usr/bin/env bats

@test "iaas-python-linter: valid python" {
  run ./actions/iaas-python-linter/script.sh ./actions/iaas-python-linter/test/data/valid.py
  echo "${output}"
  [ "$status" -eq 0 ]
}

@test "iaas-python-linter: invalid python with fatal" {
  run ./actions/iaas-python-linter/script.sh ./actions/iaas-python-linter/test/data/fatal.py
  echo "$output"
  echo "$status"
  [ "$status" -eq 1 ]
}

@test "iaas-python-linter: invalid python with warn" {
  run ./actions/iaas-python-linter/script.sh ./actions/iaas-python-linter/test/data/warn.py
  echo "$output"
  echo "$status"
  [ "$status" -eq 4 ]
}

@test "iaas-python-linter: invalid python with warn/error" {
  run ./actions/iaas-python-linter/script.sh ./actions/iaas-python-linter/test/data/error.py
  echo "$output"
  echo "$status"
  [ "$status" -eq 6 ]
}

@test "iaas-python-linter: invalid python with refactor" {
  run ./actions/iaas-python-linter/script.sh ./actions/iaas-python-linter/test/data/refactor.py
  echo "$output"
  echo "$status"
  [ "$status" -eq 8 ]
}

@test "iaas-python-linter: invalid python with convention" {
  run ./actions/iaas-python-linter/script.sh ./actions/iaas-python-linter/test/data/convention.py
  echo "$output"
  echo "$status"
  [ "$status" -eq 16 ]
}

@test "iaas-python-linter: error no workspace provided and exit with 99" {
  run ./actions/iaas-yaml-linter/script.sh
  [ "$status" -eq 99 ]
  [ "$output" == "ERROR:, script.sh, line 7, At least one file is required" ]
}

@test "iaas-python-linter: error no files found" {
  run ./actions/python-yaml-linter/script.sh foo.py
  echo "$output"
  echo "$status"
  [ "$status" -eq 127 ]
}
