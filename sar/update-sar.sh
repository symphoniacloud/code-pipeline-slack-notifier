#!/bin/bash

set -eu

# ./upload-package.sh

# THIS DOESN'T WORK EITHER - also failing on the source-code-url
# aws serverlessrepo create-application-version \
# --application-id 'arn:aws:serverlessrepo:us-east-1:392967531616:applications/CodePipelineSlackNotifier' \
# --semantic-version '1.0.1' \
# --template-body target/packaged-template.yaml \
# --source-code-url 'https://github.com/symphoniacloud/code-pipeline-slack-notifier'

# aws serverlessrepo create-application \
# --author "Symphonia" \
# --description "Post notifications to Slack when Code Pipeline Events occur" \
# --labels "CodePipeline" "Slack" \
# --license-body LICENSE \
# --name "CodePipelineSlackNotifier" \
# --readme-body README-SAR.md \
# --semantic-version "1.0.0" \
# --spdx-license-id "Apache-2.0" \
# --template-body target/packaged-template.yaml \
# --source-code-url https://github.com/symphoniacloud/code-pipeline-slack-notifier
