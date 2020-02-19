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
    bin/bash
