#!/usr/bin/env bash

set -euo pipefail

cli_bin=""
if command -v erda-cli >/dev/null 2>&1; then
  cli_bin="erda-cli"
elif command -v erda >/dev/null 2>&1; then
  cli_bin="erda"
else
  echo "Neither erda-cli nor erda was found in PATH."
  echo "Install the ERDA CLI first, then authenticate before using this skill."
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
echo "  2. linked worktrees are supported; run git status --short before pipeline run"
echo "  3. after push, check pipeline history --branch <branch> before creating a run"
echo "  4. reuse an existing pipeline ID when history or a deployment lock identifies one"
echo "  5. after watch re-authentication, query the original pipeline ID"
echo "  6. use a normal clone only for isolation or reproduction; verify git remote -v and .erda.d/config there"
echo "  7. prefer erda-cli -V pipeline run for run-time diagnostics"
