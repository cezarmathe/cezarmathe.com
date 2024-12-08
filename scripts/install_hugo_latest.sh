#!/usr/bin/env bash

set -euxo pipefail

# hugo repository
REPOSITORY="gohugoio/hugo"
# endpoint for getting the latest release
API_ENDPOINT="https://api.github.com/repos/${REPOSITORY}/releases/latest"
# endpoint for getting the artifacts for hugo
DOWNLOAD_ENDPOINT="https://github.com/${REPOSITORY}/releases/download"

function main() {
    local version="$(curl -fsSL ${API_ENDPOINT} \
        | jq -r .tag_name \
        | tr -d 'v')"

    local hugo_shasums="hugo_${version}_checksums.txt"
    local hugo_deb="hugo_${version}_Linux-64bit.deb"

    wget "${DOWNLOAD_ENDPOINT}/v${version}/${hugo_shasums}"
    wget "${DOWNLOAD_ENDPOINT}/v${version}/${hugo_deb}"

    sha256sum --check "${hugo_shasums}" --ignore-missing

    sudo dpkg -i "${hugo_deb}"

    rm "${hugo_shasums}" "${hugo_deb}"
}

main $@
