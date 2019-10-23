#!/bin/bash

set -e

echo "# Ensure all pre requisites are met"
echo "-----------------------------------"

sudo yum install -y jq unzip net-tools

echo "# Retrieve CA Certificate Chain from Vault SSH CA Configuration"
echo "---------------------------------------------------------------"

