#!/bin/bash

usage="Usage: update-sar.sh -id SAR-APP-ID -v SEMANTIC-VERSION"

while [[ $# -gt 1 ]]
do
KEY="$1"

case $KEY in
    -id)
    SAR_APP_ID="$2"
    shift # past argument
    ;;
    -v|--version)
    SEMANTIC_VERSION="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [[ -z "$SAR_APP_ID" ]]; then
    echo "SAR-APP-ID not set"
    echo "$usage"
    exit 1
fi

if [[ -z "$SEMANTIC_VERSION" ]]; then
    echo "SEMANTIC-VERSION not set"
    echo "$usage"
    exit 1
fi

set -eu

if [ ! -f ../target/packaged-template.yaml ]; then
    echo "Unable to find target/packaged-template.yaml - did you run upload-package successfully? Are you running from the sar directory?"
    exit 1
fi

aws serverlessrepo create-application-version \
--application-id $SAR_APP_ID \
--semantic-version $SEMANTIC_VERSION \
--template-body "file://../target/packaged-template.yaml" \
--region us-east-1
