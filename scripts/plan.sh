#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../terraform" && pwd)"
cd "$ROOT"
terraform init -backend=false
terraform fmt -check
terraform validate
terraform plan
