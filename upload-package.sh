#!/bin/bash

set -eu

npm install
npm run test
npm run dist
aws cloudformation package --template-file sam.yml --s3-bucket symphonia-oss --s3-prefix "sar/code-pipeline-slack-notifier" --output-template-file target/packaged-template.yaml
cp ./target/packaged-template.yaml ./prebuilt-templates/
