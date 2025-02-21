#!/bin/bash

set -eux -o pipefail

if [ "$#" -eq  "0" ]
then
    echo "No arguments supplied. Usage: ./scripts/backend-setup.sh BACKENDFILE. Example: ./scripts/backend-setup.sh env/dev.tfbackend"
    exit 1
fi

source $1

# Authenticate doctl with your DigitalOcean account using your API token
doctl auth init

# Create a project
doctl projects create --name "$project_name" --purpose "$project_purpose"

# Get the project ID
project_id=$(doctl projects list --format ID,Name | grep "$project_name" | awk '{print $1}')

# Assign the Space to the project
doctl projects resources assign "$project_id" --resource do:space:"$bucket"