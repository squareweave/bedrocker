#!/bin/bash

set -e

declare -A bedrockShaKeys

bedrockShaKeys=(
	[1.6.2]='2f7dc9670855458f78349b5dd7f1eb98ac360fe8'
	[1.6.3]='ecc65a6f13eecfc9f4867596d90b72f3498d1363'
)

wpCliVersion=0.23.1
wpCliShaKey=359b41d7cabd4f1a6ea83400b6a337443e6e7331
composerSetupShaKey=070854512ef404f16bac87071a6db9fd9721da1684cd4589b1196c3faf71b9a2682e2311b36a5079825e155ac7ce150d

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
    bedrockShaKey="${bedrockShaKeys[$version]}"
    if [ -z "$bedrockShaKey" ]; then
        echo >&2 "ERROR: missing SHA1 key fingerprint for $version"
        exit 1
    fi

    dockerfiles=()

    mkdir -p $version $version/node

    {
        cat Dockerfile.template
    } > "$version/Dockerfile"

    {
        cat Dockerfile.template
        echo ""
        echo ""
        cat Dockerfile.node.template
    } > $version/node/Dockerfile

    dockerfiles+=( "$version/Dockerfile" )
    dockerfiles+=( "$version/node/Dockerfile" )

    (
        set -x
        sed -ri '
            s!%%BEDROCK_VERSION%%!'"$version"'!;
            s!%%BEDROCK_SHA1%%!'"$bedrockShaKey"'!;
            s!%%WP_CLI_VERSION%%!'"$wpCliVersion"'!;
            s!%%WP_CLI_SHA1%%!'"$wpCliShaKey"'!;
            s!%%COMPOSER_SETUP_SHA384%%!'"$composerSetupShaKey"'!;
        ' "${dockerfiles[@]}"
    )

    cp wordpress-rewrite.conf $version
    cp wordpress-rewrite.conf $version/node
done
