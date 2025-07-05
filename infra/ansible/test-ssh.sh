#!/bin/bash
SERVER_IP="192.168.56.10"
SERVER_USER="ubuntu"
PRIVATE_KEY_PATH="./id_rsa"

echo "[🔌] Test SSH à $SERVER_USER@$SERVER_IP"
ssh -i "$PRIVATE_KEY_PATH" -o StrictHostKeyChecking=no \
    "$SERVER_USER@$SERVER_IP" "echo '✅ Connexion SSH OK'" || exit 1