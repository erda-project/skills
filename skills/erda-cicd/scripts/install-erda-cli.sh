#!/usr/bin/env bash

set -euo pipefail

INSTALL_SCRIPT_URL="${ERDA_CLI_INSTALL_SCRIPT_URL:-https://erda-release.oss-cn-hangzhou.aliyuncs.com/cli/scripts/install.sh}"
INSTALL_CHANNEL="${ERDA_CLI_CHANNEL:-alpha}"
DEFAULT_INSTALL_DIR="${ERDA_CLI_INSTALL_DIR:-${HOME}/.erda/bin}"

ensure_erda_cli_on_path() {
  if command -v erda-cli >/dev/null 2>&1; then
    return 0
  fi

  if [[ -x "${DEFAULT_INSTALL_DIR}/erda-cli" ]]; then
    export PATH="${DEFAULT_INSTALL_DIR}:${PATH}"
  fi
}

install_erda_cli() {
  echo "erda-cli not found. Installing erda-cli from ${INSTALL_CHANNEL} channel..."
  curl -fsSL "${INSTALL_SCRIPT_URL}" | bash -s -- "${INSTALL_CHANNEL}"
  ensure_erda_cli_on_path
}

update_erda_cli() {
  if ! command -v erda-cli >/dev/null 2>&1; then
    echo "erda-cli install completed, but erda-cli is still not available in PATH." >&2
    echo "Add ${DEFAULT_INSTALL_DIR} to PATH and rerun this script." >&2
    exit 1
  fi

  echo "Using erda-cli: $(command -v erda-cli)"
  erda-cli update set-default "${INSTALL_CHANNEL}"
  erda-cli update
}

ensure_erda_cli_on_path
if ! command -v erda-cli >/dev/null 2>&1; then
  install_erda_cli
else
  echo "erda-cli detected. Checking for updates on ${INSTALL_CHANNEL} channel..."
fi

update_erda_cli
