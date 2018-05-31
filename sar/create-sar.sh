#!/bin/bash

usage="Usage: create-sar.sh -n SAR-APP-NAME"

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

aws serverlessrepo create-application \
--author "Symphonia" \
--description "Post notifications to Slack when Code Pipeline Events occur" \
--home-page-url "https://github.com/symphoniacloud/code-pipeline-slack-notifier" \
--labels "CodePipeline" "Slack" \
--license-body "https://raw.githubusercontent.com/symphoniacloud/code-pipeline-slack-notifier/master/LICENSE" \
--name $SAR_APP_NAME \
--source-code-url "https://github.com/symphoniacloud/code-pipeline-slack-notifier" \
--spdx-license-id "Apache-2.0" \
--readme-body "https://raw.githubusercontent.com/symphoniacloud/code-pipeline-slack-notifier/master/sar/README-SAR.md" \
--region us-east-1
