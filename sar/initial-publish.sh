#!/bin/bash

usage="Usage: initial-publish.sh -n SAR-APP-NAME"

while [[ $# -gt 1 ]]
do
KEY="$1"

case $KEY in
    -n|--name)
    SAR_APP_NAME="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [[ -z "$SAR_APP_NAME" ]]; then
    echo "SAR-APP-NAME not set"
    echo "$usage"
    exit 1
fi

set -eu

if [ ! -f target/packaged-template.yaml ]; then
    echo "Unable to find target/packaged-template.yaml - did you run upload-package successfully? Are you running from the repository root"
fi

# THIS DOESN'T WORK! :) So created manually
# AWS CLI barfing on source-code-url, and if that's taken out then it complains with:
# An error occurred (BadRequestException) when calling the CreateApplication operation: Resource with name [template] is invalid. Expected input as dictionary, instead got <type 'str'>

aws serverlessrepo create-application \
--author "Symphonia" \
--description "Post notifications to Slack when Code Pipeline Events occur" \
--labels "CodePipeline" "Slack" \
--license-body LICENSE \
--name "CodePipelineSlackNotifier" \
--readme-body sar/README-SAR.md \
--semantic-version "1.0.0" \
--spdx-license-id "Apache-2.0" \
--template-body target/packaged-template.yaml \
--source-code-url https://github.com/symphoniacloud/code-pipeline-slack-notifier
