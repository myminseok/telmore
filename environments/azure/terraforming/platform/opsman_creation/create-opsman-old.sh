#!/bin/bash 

set -eux

# TODO: Use a variable for the foundation name.
#pivnet download opsmanager

docker run -it -v $HOME/workspace/afc_terraforming:/workspace platform-automation-image \
    p-automator create-vm \
        --config "/workspace/opsman_creation/sandbox/ops-manager.yml" \
        --image-file "/workspace/opsman_creation/ops-manager-azure-2.8.2-build.203.yml"  \
        --state-file /workspace/secrets/sandbox/opsman-state.yml \
        --vars-file /workspace/secrets/sandbox/output.json \
        --vars-file /workspace/secrets/sandbox/creds.yml
