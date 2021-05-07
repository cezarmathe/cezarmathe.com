#!/usr/bin/env bash

set -euxo pipefail

# hugo repository
REPOSITORY="gohugoio/hugo"
# endpoint for getting the latest release
API_ENDPOINT="https://api.github.com/repos/${REPOSITORY}/releases/latest"
# endpoint for getting the artifacts for hugo
DOWNLOAD_ENDPOINT="https://github.com/${REPOSITORY}/releases/download"

wget "${DOWNLOAD_ENDPOINT}/v${LATEST_VERSION}/hugo_${LATEST_VERSION}_checksums.txt"
wget "${DOWNLOAD_ENDPOINT}/v${LATEST_VERSION}/hugo_extended_${LATEST_VERSION}_Linux-64bit.deb"

sha256sum --check "hugo_${LATEST_VERSION}_checksums.txt" --ignore-missing

sudo apt install "hugo_extended_${latest_version}_Linux-64bit.deb"
rm -rf "hugo_extended_${latest_version}_Linux-64bit.deb"

function main() {
    sudo apt update
    sudo apt install curl jq wget

    local version="$(curl -fsSL ${API_ENDPOINT} \
        | jq -r .tag_name \
        | tr -d 'v')"

    local hugo_shasums="hugo_${version}_checksums.txt"
    local hugo_deb="hugo_extended_${version}_Linux-64bit.deb"

    wget "${DOWNLOAD_ENDPOINT}/v${version}/${hugo_shasums}"
    wget "${DOWNLOAD_ENDPOINT}/v${version}/${hugo_deb}"

    sha256sum --check "${hugo_shasums}" --ignore-missing

    sudo apt install "${hugo_deb}"

    rm "${hugo_shasums}" "${hugo_deb}"
}

main $@
