#!/bin/bash

set -e

echo "# Retrieve CA Certificate Chain from Vault SSH CA Configuration"
echo "---------------------------------------------------------------"

sudo curl -o /etc/ssh/trusted-user-ca-keys.pem http://${vault_fqdn}:8200/v1/ssh-ca-client-signer/public_key

echo "# Modifying sshd_config for adding CA Certificate Chain file path"
echo "-----------------------------------------------------------------"

sudo echo "" >> /etc/ssh/sshd_config
sudo echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config

echo "# Restart SSHD Service to tkae chane into account"
echo "-------------------------------------------------"

sudo systemctl restart sshd