#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
for f in terraform/versions.tf terraform/providers.tf terraform/variables.tf terraform/networking.tf terraform/security.tf terraform/alb.tf terraform/compute.tf terraform/database.tf terraform/storage.tf terraform/outputs.tf terraform/userdata.sh; do
  test -s "$ROOT/$f"
done
grep -q 'publicly_accessible *= *false' "$ROOT/terraform/database.tf"
grep -q 'storage_encrypted *= *true' "$ROOT/terraform/database.tf"
grep -q 'http_tokens *= *"required"' "$ROOT/terraform/compute.tf"
grep -q 'block_public_acls *= *true' "$ROOT/terraform/storage.tf"
grep -q 'security_groups *= *\[aws_security_group.alb.id\]' "$ROOT/terraform/security.tf"
grep -q 'security_groups *= *\[aws_security_group.app.id\]' "$ROOT/terraform/security.tf"
echo 'Project 31 structure/security assertions passed.'
