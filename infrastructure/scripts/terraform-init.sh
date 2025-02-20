#!/usr/bin/env bash

set -eux -o pipefail

if [ "$#" -eq  "0" ]
then
    echo "No arguments supplied. Usage: ./scripts/terraform-init.sh BACKENDFILE. Example: ./scripts/terraform-init.sh dev.tfbackend"
    exit 1
fi

terraform init -reconfigure \
    -backend-config="$1"