#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_install_dir="${ERDA_CLI_INSTALL_DIR:-${HOME}/.erda/bin}"
cli_bin=""

if ! command -v erda-cli >/dev/null 2>&1; then
  echo "erda-cli was not found in PATH."
  echo "Installing erda-cli before continuing..."
  bash "${script_dir}/install-erda-cli.sh"
  export PATH="${default_install_dir}:${PATH}"
else
  bash "${script_dir}/install-erda-cli.sh"
fi

if command -v erda-cli >/dev/null 2>&1; then
  cli_bin="erda-cli"
elif command -v erda >/dev/null 2>&1; then
  cli_bin="erda"
else
  echo "Neither erda-cli nor erda was found in PATH after installation."
  exit 1
fi

echo "ERDA CLI detected: ${cli_bin}"
echo "Verification commands:"
echo "  ${cli_bin} version"
echo "  ${cli_bin} whoami"
echo "  ${cli_bin} pipeline --help"
echo
echo "cicd workflow checks:"
echo "  1. confirm CLI auth before pipeline run, status, history, or logs"
echo "  2. run git status --short before pipeline run"
echo "  3. if the workspace is dirty, prefer a temporary clean clone over worktree"
echo "  4. in a clean clone, verify git remote -v and .erda.d/config context"
echo "  5. prefer erda-cli -V pipeline run for run-time diagnostics"
