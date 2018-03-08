#!/bin/bash

set -eu

# THIS DOESN'T WORK! :) So created manually
# AWS CLI barfing on source-code-url, and if that's taken out then it complains with:
# An error occurred (BadRequestException) when calling the CreateApplication operation: Resource with name [template] is invalid. Expected input as dictionary, instead got <type 'str'>
# Mikes-MacBook-Pro-2:code-pipeline-slack-notifier mike$ cat target/packaged-template.yaml

# ./upload-package.sh

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
