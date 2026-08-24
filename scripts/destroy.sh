#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../terraform" && pwd)"
cd "$ROOT"
read -r -p "Type DESTROY to continue: " answer
[[ "$answer" == "DESTROY" ]] || { echo "aborted"; exit 1; }
terraform destroy
