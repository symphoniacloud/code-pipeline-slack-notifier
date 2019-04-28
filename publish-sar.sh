#!/bin/sh

set -eu

rm -rf target
npm run test
npm run dist
sam package --region us-east-1 --template-file sam.yaml --output-template-file target/packaged.yaml --s3-bucket sam-artifacts-392967531616-us-east-1
sam publish --region us-east-1 --template target/packaged.yaml