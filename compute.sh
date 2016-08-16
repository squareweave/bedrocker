#!/bin/bash -xe

[ -z $VERSION ] && exit 1

curl -sS -o /tmp/bedrock.tar.gz \
    -L https://github.com/roots/bedrock/archive/${VERSION}.tar.gz

BEDROCK_SHA1=$(sha1sum /tmp/bedrock.tar.gz | awk '{print $1}')

echo "Computed SHA1 hash: ${BEDROCK_SHA1}"
echo "$BEDROCK_SHA1 */tmp/bedrock.tar.gz" | sha1sum -c -