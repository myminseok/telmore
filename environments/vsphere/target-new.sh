export OM_USERNAME=admin
export OM_PASSWORD=bullswin
export OM_TARGET=https://new-opsman.haas-244.pez.pivotal.io

eval "$(om bosh-env)"

export BOSH_ALL_PROXY="ssh+socks5://ubuntu@new-opsman.haas-244.pez.pivotal.io:22?private-key=/Users/anthonyelmore/.ssh/id_rsa"
