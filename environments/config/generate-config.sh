#!/bin/bash -e
: ${PIVNET_TOKEN?"Need to set PIVNET_TOKEN"}

INITIAL_FOUNDATION=nttwtcdev
if [ ! $# -eq 2 ]; then
  echo "Must supply iaas and product name as arg"
  exit 1
fi

iaas=$1
product=$2

echo "Generating configuration for product $product"
versionfile="../${iaas}/${INITIAL_FOUNDATION}/versions/$product.yml"
if [ ! -f ${versionfile} ]; then
  echo "Must create ${versionfile}"
  exit 1
fi
version=$(bosh interpolate ${versionfile} --path /product-version)
glob=$(bosh interpolate ${versionfile} --path /pivnet-file-glob)
slug=$(bosh interpolate ${versionfile} --path /pivnet-product-slug)

tmpdir=tile-configs/${product}-config
mkdir -p ${tmpdir}
om config-template --output-directory=${tmpdir} --pivnet-api-token ${PIVNET_TOKEN} --pivnet-product-slug  ${slug} --product-version ${version} --product-file-glob ${glob}
wrkdir=$(find ${tmpdir}/${product} -name "${version}*")
if [ ! -f ${wrkdir}/product.yml ]; then
  echo "Something wrong with configuration as expecting ${wrkdir}/product.yml to exist"
  exit 1
fi

ops_files="../${iaas}/opsfiles/${product}-operations"
touch ${ops_files}

ops_files_args=("")
while IFS= read -r var
do
  ops_files_args+=("-o ${wrkdir}/${var}")
done < "$ops_files"
bosh int ${wrkdir}/product.yml ${ops_files_args[@]} > ../${iaas}/${INITIAL_FOUNDATION}/config/templates/${product}.yml

mkdir -p ../${iaas}/${INITIAL_FOUNDATION}/config/defaults
rm -rf ../${iaas}/${INITIAL_FOUNDATION}/config/defaults/${product}.yml
touch ../${iaas}/${INITIAL_FOUNDATION}/config/defaults/${product}.yml
if [ -f ${wrkdir}/product-default-vars.yml ]; then
  cat ${wrkdir}/product-default-vars.yml >> ../${iaas}/${INITIAL_FOUNDATION}/config/defaults/${product}.yml
fi
if [ -f ${wrkdir}/errand-vars.yml ]; then
  cat ${wrkdir}/errand-vars.yml >> ../${iaas}/${INITIAL_FOUNDATION}/config/defaults/${product}.yml
fi
if [ -f ${wrkdir}/resource-vars.yml ]; then
  cat ${wrkdir}/resource-vars.yml >> ../${iaas}/${INITIAL_FOUNDATION}/config/defaults/${product}.yml
fi

touch ../${iaas}/${INITIAL_FOUNDATION}/config/secrets/${product}.yml