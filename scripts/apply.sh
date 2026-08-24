#!/usr/bin/env bash
set -euo pipefail
: "${TF_VAR_db_password:?Set TF_VAR_db_password before apply}"
ROOT="$(cd "$(dirname "$0")/../terraform" && pwd)"
cd "$ROOT"
terraform init
terraform validate
terraform plan
read -r -p "Apply the reviewed plan? Type APPLY: " answer
[[ "$answer" == "APPLY" ]] || { echo "aborted"; exit 1; }
terraform apply
