#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../lib/log.sh"
}

@test "log_info outputs INFO prefix" {
  run log_info "hello"
  [ "$status" -eq 0 ]
  [[ "$output" == *"INFO"* ]]
  [[ "$output" == *"hello"* ]]
}

@test "log_success outputs OK prefix" {
  run log_success "done"
  [ "$status" -eq 0 ]
  [[ "$output" == *"OK"* ]]
}

@test "log_warn outputs WARN prefix" {
  run log_warn "careful"
  [ "$status" -eq 0 ]
  [[ "$output" == *"WARN"* ]]
}

@test "log_error outputs ERROR prefix to stderr" {
  run bash -c "source \"$BATS_TEST_DIRNAME/../lib/log.sh\"; log_error \"failed\" 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"ERROR"* ]]
  [[ "$output" == *"failed"* ]]
}

@test "log_step outputs numbered step" {
  run log_step 3 "doing thing"
  [ "$status" -eq 0 ]
  [[ "$output" == *"[3]"* ]]
  [[ "$output" == *"doing thing"* ]]
}
