# Mac Languages Skill

Install or update language runtimes on this Mac.

## Usage

Invoke when the user wants to install, update, or check language versions.

## Supported Languages

| Language | Manager | Install command |
|---|---|---|
| Node.js | nvm | `nvm install --lts` |
| Python | pyenv | `pyenv install <version>` |
| Java | SDKMAN | `sdk install java` |
| Scala | SDKMAN | `sdk install scala` |
| Go | Homebrew | `brew install go` |
| Rust | rustup | `rustup update` |

## Actions

1. Run `./bootstrap.sh --only languages` to install all runtimes
2. For a specific language: run the appropriate sub-command above
3. Check current versions:
   ```bash
   node --version && python --version && java -version && go version && rustc --version
   ```
