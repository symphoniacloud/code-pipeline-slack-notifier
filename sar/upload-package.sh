#!/bin/bash

usage="Usage: upload-package.sh -b BUCKET"

while [[ $# -gt 1 ]]
do
KEY="$1"

case $KEY in
    -b|--bucket)
    BUCKET="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [[ -z "$BUCKET" ]]; then
    echo "BUCKET not set"
    echo "$usage"
    exit 1
fi

set -eu

npm install
npm run test
npm run dist
aws cloudformation package --template-file ../sam.yml --s3-bucket $BUCKET --s3-prefix "sar/code-pipeline-slack-notifier" --output-template-file target/packaged-template.yaml
cp ../target/packaged-template.yaml ../prebuilt-templates/
