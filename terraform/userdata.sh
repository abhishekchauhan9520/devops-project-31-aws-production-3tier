#!/usr/bin/env bash
set -euo pipefail
dnf update -y
dnf install -y nginx
mkdir -p /usr/share/nginx/html
cat >/usr/share/nginx/html/index.html <<'EOF'
<!doctype html><html><body><h1>Project 31 - AWS 3-Tier Platform</h1><p>Served from a private application tier.</p></body></html>
EOF
cat >/etc/nginx/conf.d/project31.conf <<'EOF'
server { listen 8080; server_name _; location /health { return 200 'ok'; add_header Content-Type text/plain; } location / { root /usr/share/nginx/html; index index.html; } }
EOF
systemctl enable nginx
systemctl restart nginx
