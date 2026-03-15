#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../lib/prompt.sh"
}

@test "prompt_yn returns 0 for 'y' input" {
  run prompt_yn "Continue?" <<< "y"
  [ "$status" -eq 0 ]
}

@test "prompt_yn returns 1 for 'n' input" {
  run prompt_yn "Continue?" <<< "n"
  [ "$status" -eq 1 ]
}

@test "prompt_yn returns 0 for empty input (default yes)" {
  run prompt_yn "Continue?" "y" <<< ""
  [ "$status" -eq 0 ]
}

@test "prompt_text returns entered value" {
  run prompt_text "Name:" <<< "Jerome Banks"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Jerome Banks"* ]]
}

@test "prompt_secret returns entered value" {
  run prompt_secret "Secret:" <<< "mysecret"
  [ "$status" -eq 0 ]
  [[ "$output" == *"mysecret"* ]]
}
