#!/bin/bash

set -eu

# Now perform deployment using AWS SAM package and deploy commands
aws cloudformation package \
    --template-file template.yaml \
    --s3-bucket {{ cookiecutter.s3_deployment_bucket }} \
    --output-template-file packaged-template.yaml

aws cloudformation deploy \
    --template-file packaged-template.yaml \
    --stack-name {{ cookiecutter.project_name }} \
    --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND

echo
echo "** Serverless application deployed!"
echo "** Application / Stack name: {{ cookiecutter.project_name }}"
echo
