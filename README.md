## About the Guidance

In this [Guidance](#put-link-here), we will dive deep into the concepts of KEDA with examples. As part of this exercise, we will also learn how using KEDA can lower compute cost scaling Kubernetes Pods based on events like the amount of messages in [Amazon SQS](https://aws.amazon.com/sqs/) Queue or customized metrics from [Amazon Managed Service for Prometheus](https://aws.amazon.com/prometheus/).

## About KEDA

[KEDA](https://keda.sh/) is a single-purpose and lightweight component that can be added into any Kubernetes cluster. KEDA works alongside standard Kubernetes components like the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) and can extend functionality without overwriting or duplication. Currently, KEDA has over 60 scalers available to detect if a deployment should be activated or deactivated, and feed custom metrics for a specific event source. 

Current default Kubernetes scaling mechanism based on CPU and memory utilization are not efficient enough for event-driven applications. Those mechanisms lead to over or under provisioned resources that might generate a poor cost efficiency or customer experience. KEDA enables scaling based on custom metrics. For example, business metrics like the amount of orders or payments waiting to be processed, or technical metrics, like the number of concurrent requests or response time.

## Architecture

![](assets/keda-architecture.png)
Figure 1: KEDA architecture on AWS

### Architecture steps
1. App using Amazon SQS to decouple communication between microservices.
2. AWS Distro for OpenTelemetry (ADOT) gets metrics from application and sends to Amazon Managed Prometheus (AMP).
3. KEDA configured to use Amazon SQS and Prometheus scaler to get SQS queue length and Prometheus custom metrics.
4. KEDA (keda-operator-metrics-apiserver) exposes event data for HPA to scale.
5. Horizontal Pod Autoscaling (HPA) scales the number of pods.
6. Cluster Autoscaling (CA) provisions the required nodes using auto scaling group (works with Karpenter as well)
7. New Capacity provisioned as required.
8. Amazon Managed Grafana (AMG) **optionally** configured to show metrics from AMP in a dashboard.


## Understanding the project structure

1. Starting with ```/keda``` folder, where it's compose by files regarding Keda, such as Keda operator policy and values.


2. In the ```/scaledobject-samples``` folder, it's composed by files regarding the **ScaledObject**, containing the following subfolders:

    2.1. In the ```/amazonsqs``` folder are the files referring to the application that will consume the messages from Amazon SQS queue together with its **ScaledObject**.

    2.2. In the ```/prometheus``` folder are the files related to the application configurations that will consume custom metrics from [Amazon Prometheus](https://aws.amazon.com/prometheus/) together with its **ScaledObject**.

3. And in the ```/setup``` folder are the files related to the Amazon EKS cluster setup.


## Pre requirements

- Set up [AWS Cloud9](https://aws.amazon.com/cloud9/) Environment.
- Clone this Github repository to the Cloud9 environment you have created.
- Execute the setup script: ``` chmod +x setup/*.sh ./setup/tools.sh```

The ```tools.sh``` script in AWS Cloud9 terminal will install the following tools and configure them:

- eksctl
- kubectl
- awscli
- Helm CLI
- jq, envsubst (from GNU gettext utilities) and bash-completion
- Install k9s a Kubernetes CLI to Manage Your Clusters in Style
- Enable kubectl bash_completion
- Verify the binaries are in the path and executable
- Enable some kubernetes aliases
- Configure aws cli with your current region as default.
- Save these into bash_profile

#### Create EKS Cluster
- Execute the following scripts to setup environment variables and deploy Amazon EKS cluster:

``` 
./setup/env.sh

source /home/ec2-user/.bashrc 

eksctl create cluster -f setup/cluster.yaml 
```

#### Create the IAM OIDC Identity Provider
- Create the IAM OIDC Identity Provider for the cluster:

```  eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve ```

```echo "export OIDC_ID=$(aws eks describe-cluster --name $CLUSTER_NAME --query 'cluster.identity.oidc.issuer' --output text | cut -d '/' -f 5)" >> /home/ec2-user/.bashrc && source /home/ec2-user/.bashrc``` 

#### Test access to EKS cluster
- ```kubectl get nodes```


## Continue implementing the Guidance

To continue implementing the Guidance click  **[HERE](#put-link-here)** to learn more.


## Main services that make up the guidance.

- [Amazon Elastic Kubernetes Services (EKS)](https://aws.amazon.com/eks/)
- [Amazon SQS](https://aws.amazon.com/sqs/)
- [Amazon Managed Service for Prometheus](https://aws.amazon.com/prometheus/)
- [AWS Distro for OpenTelemetry (ADOT)](https://aws-otel.github.io/)
- [Amazon Managed Grafana](https://aws.amazon.com/grafana/) (optional)


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.