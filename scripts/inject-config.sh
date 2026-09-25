#!/usr/bin/env bash
# Inject 1Password secrets into a machine-local JSON config (outside the TwinCAT repo).
# Optional Linux/BSD helper; primary path on IPC is inject-config.ps1.
set -euo pipefail

TEMPLATE_PATH="${1:-templates/machine.json.tpl}"
OUT_DIR="${2:-${MACHINE_CONFIG_DIR:-/etc/MachineConfig}}"
OUT_NAME="${3:-machine.json}"

if ! command -v op >/dev/null 2>&1; then
  echo "error: 1Password CLI 'op' not found on PATH" >&2
  echo "Install: https://developer.1password.com/docs/cli/get-started/" >&2
  exit 1
fi

if [[ ! -f "$TEMPLATE_PATH" ]]; then
  echo "error: template not found: $TEMPLATE_PATH" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
OUT_PATH="${OUT_DIR%/}/$OUT_NAME"

echo "Injecting secrets from template into machine-local config..."
echo "  Template: $TEMPLATE_PATH"
echo "  Output:   $OUT_PATH"

op inject -i "$TEMPLATE_PATH" -o "$OUT_PATH"
echo "Success. Config written to: $OUT_PATH"
echo "(Secret values are not echoed.)"
