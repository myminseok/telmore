#!/bin/bash 

set -eux

# TODO: Use a variable for the foundation name.
#pivnet download opsmanager
foundation="sbx"

secrets_folder=/Volumes/Keybase/private/tonyelmore/dev/telmore/environments/azure/terraforming/secrets/${foundation}
workspace=${PWD}/${foundation}

docker run -it \
    -v "${workspace}":/workspace \
    -v "${secrets_folder}":/secrets \
    cloudfoundry/platform-automation:4.3.2 \
    p-automator create-vm \
        --config "/workspace/ops-manager.yml" \
        --image-file "/workspace/ops-manager-azure-2.8.2-build.203.yml"  \
        --state-file /workspace/opsman-state.yml \
        --vars-file /secrets/output.json \
        --vars-file /secrets/creds.yml