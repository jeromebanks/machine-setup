#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../lib/backup.sh"
  BACKUP_ROOT="$BATS_TMPDIR/test-backups"
  export BACKUP_ROOT
  TEST_FILE="$BATS_TMPDIR/test-file.txt"
  echo "original content" > "$TEST_FILE"
}

teardown() {
  rm -rf "$BACKUP_ROOT" "$TEST_FILE"
}

@test "backup_file creates backup directory" {
  run backup_file "$TEST_FILE"
  [ "$status" -eq 0 ]
  [ -d "$BACKUP_ROOT" ]
}

@test "backup_file copies file content" {
  backup_file "$TEST_FILE"
  BACKED_UP=$(find "$BACKUP_ROOT" -name "test-file.txt" | head -1)
  [ -f "$BACKED_UP" ]
  run cat "$BACKED_UP"
  [[ "$output" == "original content" ]]
}

@test "backup_file returns 1 if file does not exist" {
  run backup_file "/tmp/__no_such_file_xyz__"
  [ "$status" -eq 1 ]
}

@test "backup_file skips if BACKUP_ENABLED=false" {
  export BACKUP_ENABLED=false
  run backup_file "$TEST_FILE"
  [ "$status" -eq 0 ]
  [ ! -d "$BACKUP_ROOT" ]
  unset BACKUP_ENABLED
}
