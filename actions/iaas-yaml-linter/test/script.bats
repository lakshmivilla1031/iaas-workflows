#!/usr/bin/env bats

@test "iaas-yaml-linter: valid yaml" {
  run ./actions/iaas-yaml-linter/script.sh ./actions/iaas-yaml-linter/test/data/valid.yaml
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = '-----------YAMLLINT---------------------' ]
  [ "${lines[1]}" = 'YamlLint running, we are checking the following list: "./actions/iaas-yaml-linter/test/data/valid.yaml"' ]
  [ "${lines[2]}" = 'Documentation: https://www.mankier.com/1/yamllint' ]
  [ "${lines[3]}" = "INFO:, script.sh, line 14, yamllint return code 0, (0 if no errors or warnings occur)" ]
}

@test "iaas-yaml-linter: invalid with error" {
  run ./actions/iaas-yaml-linter/script.sh ./actions/iaas-yaml-linter/test/data/error.yaml
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = '-----------YAMLLINT---------------------' ]
  [ "${lines[1]}" = 'YamlLint running, we are checking the following list: "./actions/iaas-yaml-linter/test/data/error.yaml"' ]
  [ "${lines[2]}" = 'Documentation: https://www.mankier.com/1/yamllint' ]
  [ "${lines[3]}" = '::group::./actions/iaas-yaml-linter/test/data/error.yaml' ]
  [ "${lines[4]}" = "::error file=./actions/iaas-yaml-linter/test/data/error.yaml,line=8,col=5::8:5 syntax error: expected <block end>, but found '?' (syntax)" ]
  [ "${lines[5]}" = "::error file=./actions/iaas-yaml-linter/test/data/error.yaml,line=9,col=7::9:7 [indentation] wrong indentation: expected 8 but found 6" ]
  [ "${lines[6]}" = '::endgroup::' ]
  [ "${lines[7]}" = "ERROR:, script.sh, line 14, yamllint return code 1, (1 if one or more errors occur)" ]
}

@test "iaas-yaml-linter: valid yaml with warning" {
  run ./actions/iaas-yaml-linter/script.sh ./actions/iaas-yaml-linter/test/data/warning.yaml
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = '-----------YAMLLINT---------------------' ]
  [ "${lines[1]}" = 'YamlLint running, we are checking the following list: "./actions/iaas-yaml-linter/test/data/warning.yaml"' ]
  [ "${lines[2]}" = 'Documentation: https://www.mankier.com/1/yamllint' ]
  [ "${lines[3]}" = '::group::./actions/iaas-yaml-linter/test/data/warning.yaml' ]
  [ "${lines[4]}" = '::warning file=./actions/iaas-yaml-linter/test/data/warning.yaml,line=1,col=1::1:1 [document-start] missing document start "---"' ]
  [ "${lines[5]}" = '::endgroup::' ]
  [ "${lines[6]}" = 'ERROR:, script.sh, line 14, yamllint return code 2, (2 if no errors occur, but one or more warnings occur)' ]
}

@test "iaas-yaml-linter: error no workspace provided and exit with 99" {
  run ./actions/iaas-yaml-linter/script.sh
  [ "$status" -eq 99 ]
  [ "$output" = "ERROR:, script.sh, line 7, At least one file is required" ]
}

@test "iaas-yaml-linter: error no files found" {
  run ./actions/iaas-yaml-linter/script.sh foo
  [ "$status" -eq 255 ]
  [ "${lines[0]}" = '-----------YAMLLINT---------------------' ]
  [ "${lines[1]}" = 'YamlLint running, we are checking the following list: "foo"' ]
  [ "${lines[2]}" = 'Documentation: https://www.mankier.com/1/yamllint' ]
  [ "${lines[3]}" = "[Errno 2] No such file or directory: 'foo'"  ]
  [ "${lines[4]}" = "ERROR:, script.sh, line 14, yamllint return code, not caught/expected, return code: 255" ]
}
