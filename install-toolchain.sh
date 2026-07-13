#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v mise >/dev/null || {
    echo "mise is not installed."
    exit 1
}

cd "$ROOT"

mise install