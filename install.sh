#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/roman-huliak/linux-motd"
TMP_DIR="$(mktemp -d)"

# --- Check privileges ---
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

echo ">>> Downloading repository..."
curl -sL "$REPO_URL/archive/refs/heads/master.tar.gz" -o "$TMP_DIR/motd.tar.gz"
tar -xf "$TMP_DIR/motd.tar.gz" -C "$TMP_DIR"

SRC_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name "linux-motd-*")"

if [[ ! -d "$SRC_DIR" ]]; then
    echo "Error: repo extraction failed." >&2
    exit 1
fi

# --- Install MOTD script ---
echo ">>> Installing MOTD script..."
install -m 755 "$SRC_DIR/etc/update-motd.d/10-system-status" /etc/update-motd.d/10-system-status

# --- Ensure motd is empty (update-motd manages dynamic output) ---
echo ">>> Clearing /etc/motd..."
: > /etc/motd

echo ">>> Enabling SSH banner..."

cp -r "$SRC_DIR/banner" /etc/issue.net

# idempotent edit of sshd_config
if ! grep -q "^Banner /etc/issue.net" /etc/ssh/sshd_config 2>/dev/null; then
    echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
fi

echo ">>> Restarting SSH daemon..."
systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null

echo ">>> Cleaning temporary files..."
rm -rf "$TMP_DIR"

echo ">>> Installation complete."
echo "Log out and back in to see the new MOTD."
