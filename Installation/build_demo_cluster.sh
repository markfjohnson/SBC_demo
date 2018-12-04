#!/usr/bin/env bash
#!/usr/bin/env bash
set -x
eval $(maws li 110465657741_Mesosphere-PowerUser)
export AWS_DEFAULT_REGION="us-west-2"
#ssh-add ~/.ssh/id_rsa

mkdir dcos-tf-aws-demo && cd dcos-tf-aws-demo
terraform init -input=false
terraform plan -input=false -out=plan.out
terraform apply -input=false plan.out

export DCOS_MASTER="$(terraform output cluster-address | tr -d '\r')"
export public_node="$(terraform output public-agents-loadbalancer)"
dcos cluster setup --username bootstrapuser --password deleteme --no-check ${DCOS_MASTER}
dcos node


