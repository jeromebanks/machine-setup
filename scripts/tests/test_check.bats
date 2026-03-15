#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../lib/check.sh"
}

@test "command_exists returns 0 for bash" {
  run command_exists bash
  [ "$status" -eq 0 ]
}

@test "command_exists returns 1 for nonexistent command" {
  run command_exists __nonexistent_cmd_xyz__
  [ "$status" -eq 1 ]
}

@test "is_macos returns 0 on macOS" {
  if [[ "$(uname)" != "Darwin" ]]; then
    skip "not on macOS"
  fi
  run is_macos
  [ "$status" -eq 0 ]
}

@test "is_arm returns 0 on Apple Silicon" {
  if [[ "$(uname -m)" != "arm64" ]]; then
    skip "not Apple Silicon"
  fi
  run is_arm
  [ "$status" -eq 0 ]
}

@test "brew_installed returns 0 for installed formula" {
  if ! command -v brew &>/dev/null; then
    skip "brew not installed"
  fi
  if brew list git &>/dev/null; then
    run brew_installed git
    [ "$status" -eq 0 ]
  else
    skip "git not installed via brew"
  fi
}

@test "brew_installed returns 1 for missing formula" {
  if ! command -v brew &>/dev/null; then
    skip "brew not installed"
  fi
  run brew_installed __nonexistent_formula_xyz__
  [ "$status" -eq 1 ]
}

@test "path_exists returns 0 for existing path" {
  run path_exists "$BATS_TMPDIR"
  [ "$status" -eq 0 ]
}

@test "path_exists returns 1 for nonexistent path" {
  run path_exists "/tmp/__no_such_path_xyz_abc__"
  [ "$status" -eq 1 ]
}

@test "require_macos exits 1 on non-macOS" {
  if [[ "$(uname)" == "Darwin" ]]; then
    skip "running on macOS — require_macos would succeed, not exit 1"
  fi
  run require_macos
  [ "$status" -eq 1 ]
}
