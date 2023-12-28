#!/usr/bin/env bash

aws --region $AWS_REGION cloudformation create-stack --stack-name "keda-guidance" \
--template-body file://scaledobject-samples/prometheus/cloudformation/requirements.yaml

echo -n "Creating the AWS CloudFormation stack"
while [ "$(aws cloudformation describe-stacks --stack-name keda-guidance --region $AWS_REGION --output json | jq -r '.Stacks[0].StackStatus')" == "CREATE_IN_PROGRESS" ]; do
  echo -n '.'
  sleep 10
done
echo -e "\n$(aws cloudformation describe-stacks --stack-name keda-guidance --region $AWS_REGION --output json | jq -r '.Stacks[0].StackStatus')"

echo "export SAMPLE_APP_ECR=$(aws cloudformation --region $AWS_REGION describe-stacks --stack-name keda-guidance --query 'Stacks[0].Outputs[?OutputKey==`SampleAppECR`].OutputValue' --output text)" >> /home/ec2-user/.bashrc
echo "export PROMETHEUS_ENDPOINT=$(aws cloudformation --region $AWS_REGION describe-stacks --stack-name keda-guidance --query 'Stacks[0].Outputs[?OutputKey==`PrometheusEndpoint`].OutputValue' --output text)api/v1/remote_write" >> /home/ec2-user/.bashrc
echo "export PROMETHEUS_WORKSPACE=$(aws cloudformation --region $AWS_REGION describe-stacks --stack-name keda-guidance --query 'Stacks[0].Outputs[?OutputKey==`PrometheusWorkspace`].OutputValue' --output text)" >> /home/ec2-user/.bashrc

source /home/ec2-user/.bashrc