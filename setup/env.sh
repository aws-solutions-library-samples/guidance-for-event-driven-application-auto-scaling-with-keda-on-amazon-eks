echo "export AWS_REGION=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]')" >> /home/ec2-user/.bashrc
echo "export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)" >> /home/ec2-user/.bashrc
echo "export CLUSTER_NAME=eks-keda-guidance" >> /home/ec2-user/.bashrc
echo "export KEDA_NAMESPACE=keda" >> /home/ec2-user/.bashrc
echo "export KEDA_OPERATOR_ROLENAME=keda-operator-role" >> /home/ec2-user/.bashrc
source /home/ec2-user/.bashrc
envsubst < setup/cluster.yaml > /tmp/cluster.yaml && mv /tmp/cluster.yaml setup/cluster.yaml
