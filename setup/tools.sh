######################Install eksctl######################

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin

######################Install kubectl######################
sudo curl --silent --location -o /usr/local/bin/kubectl \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl

######################Install awscli######################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


######################Install Helm CLI######################

curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

######################Install jq, envsubst (from GNU gettext utilities) and bash-completion######################

sudo yum -y install jq gettext bash-completion moreutils

######################Install eks-node-viewer######################

#Install eks-node-viewer  for visualizing dynamic node usage within a cluster.

######################This step may take about 2-3 minutes to download all the dependencies and install eks-node-viewer

go install github.com/awslabs/eks-node-viewer/cmd/eks-node-viewer@latest
sudo mv -v ~/go/bin/eks-node-viewer /usr/local/bin


######################Install k9s a Kubernetes CLI To Manage Your Clusters In Style######################
curl -sS https://webinstall.dev/k9s | bash

######################Enable kubectl bash_completion######################
kubectl completion bash >>  ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion

######################Enable some kubernetes aliases######################
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
sudo curl https://raw.githubusercontent.com/blendle/kns/master/bin/kns -o /usr/local/bin/kns && sudo chmod +x $_
sudo curl https://raw.githubusercontent.com/blendle/kns/master/bin/ktx -o /usr/local/bin/ktx && sudo chmod +x $_
source ~/.bashrc


######################Configure aws cli with your current region as default######################
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)

export AWS_REGION=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]')

######################Check if AWS_REGION is set to desired region######################
test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set

######################Save these into bash_profile######################
echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
aws configure set default.region ${AWS_REGION}
aws configure get default.region


