# Mac Bootstrap Skill

Run full or partial Mac development setup from this repository.

## Usage

Invoke this skill when the user wants to set up their Mac, install tools, or run a specific setup module.

## Actions

When invoked:

1. Check that `bootstrap.sh` exists in the current repo
2. Ask which modules to run if not specified:
   - all (default)
   - system, shell, languages, dev, ai, dotfiles, remote, claude
3. Ask if dry-run mode is desired
4. Run: `./bootstrap.sh [--only <module>] [--dry-run]`
5. Report results and any manual steps needed

## Examples

- "Set up my Mac" → `./bootstrap.sh`
- "Install AI tools only" → `./bootstrap.sh --only ai`
- "Preview what remote setup would do" → `./bootstrap.sh --only remote --dry-run`
- "Set up everything except dotfiles" → `./bootstrap.sh --skip dotfiles`
