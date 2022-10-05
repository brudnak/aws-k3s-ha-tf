# AWS k3s High Availability Terraform Infrastructure

## What is the purpose of this Terraform?

For Rancher QA to easily deploy and manage AWS infrastructure for k3s high availability with an external database. 

All you have to do to get this working is three easy steps:

1. Get this repository on your local machine and setup the `terraform.tfvars` file & run `terraform init`, `terraform apply` 
2. Once `terraform apply` has finished running there will be further instructions in the output, with fully formatted and ready to go commands for you to run. Copy and paste these 7 commands and your k3s ha cluster will be up and ready.
3. Now that you have your k3s HA cluster up and ready just install Rancher on top of it following these docs: https://docs.ranchermanager.rancher.io/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster

>NOTE: WHEN INSTALLING RANCHER WITH LET'S ENCRYPT ONTO A K3S CLUSTER YOU MUST CHANGE THE `--set letsEncrypt.ingress.class=nginx` TO ` --set letsEncrypt.ingress.class=traefik`. OTHERWISE YOU'LL HAVE CERT ISSUES!

#### Example of the Output

```shell
# START OF FIRST SERVER COMMANDS
            
# Step 1: SSH into your 1st server
ssh -i $THIS_WILL_BE_YOUR_PEM_PATH ubuntu@$FIRST_SERVER_IP
            
# Step 2: Run this k3s install curl command
curl -sfL https://get.k3s.io | sh -s - server \
  --token=SECRET \
  --datastore-endpoint=$DATABASE_ENDPOINT \
  --tls-san $ROUTE_53_URL \
  --node-external-ip $FIRST_SERVER_IP
            
# Step 3: Copy the token from the following command to use with your 2nd server
sudo cat /var/lib/rancher/k3s/server/token
            
# Step 4: Get the kubeconfig for your setup
sudo cat /etc/rancher/k3s/k3s.yaml
            
# START OF SECOND SERVER COMMANDS *******************
            
# Step 1: SSH into your 2nd server
ssh -i $THIS_WILL_BE_YOUR_PEM_PATH ubuntu@$SECOND_SERVER_IP
            
# Step 2: echo and tee command the install command to a file named install.sh,
# this way you can easily use vim to paste in your token from the 1st server.
# After that you can just run bash ./install.sh

echo 'curl -sfL https://get.k3s.io | sh -s - server --token= %{for instance in aws_rds_cluster_instance.aws_rds_cluster_instance} --datastore-endpoint="mysql://tfadmin:${var.aws_rds_password}@tcp(${instance.endpoint})/k3s"%{endfor} --tls-san ${aws_route53_record.aws_route53_record.fqdn} --node-external-ip ${aws_instance.aws_instance[1].public_ip}' | tee install.sh

# Step 3: edit the install file with vim to paste in the token from the 1st server, then execute with bash
vim install.sh
bash ./install.sh
```

## Just need to create an RKE1 high availability Rancher infrastructure? Check this repository out instead

https://github.com/brudnak/aws-ha-infra

## How Should my `terraform.tfvars` File Look?

All you need to do to make this terraform work is to clone the repository and create a file called `terraform.tfvars` that sits next to the main/parent `main.tf.

How the `terraform.tfvars` file should look like:

```tf
aws_access_key        = "your-aws-access-key"
aws_secret_key        = "your-aws-secret-key"
aws_prefix            = "prefix-for-your-resources-make-it-short-3-4-characters-your-name-initials"
aws_vpc               = "look-up-your-most-used-vpc"
aws_subnet_a          = "lookup-subnet-a"
aws_subnet_b          = "lookup-subnet-b"
aws_subnet_c          = "lookup-subnet-c"
aws_ami               = "look-up-ami-you-want"
aws_subnet_id         = "look-up-your-subnet-id"
aws_security_group_id = "look-up-security-group-you-want"
aws_pem_key_name      = "name-of-your-pem-key"
aws_rds_password      = "password-for-your-rds-database-see-comment-for-aws-constraints" // AWS Constraints: At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign).
aws_route53_fqdn      = "our-most-used-route53-domain-name"
local_path_aws_pem    = "enter-the-full-path-to-the-pem-file-you-use-for-aws-on-your-local-machine"
```

### What is Getting Created?

This Terraform is mostly used for testing hosted / tenant rancher. However, you don't have to import one of the Ranchers into the other, so it can just be used to create standard k3s ha clusters.

It creates two setups, with each k3s ha having 2 nodes each. Two node high availability is the same setup that SUSE Hosted / Tenant Rancher follows.

- ec2 instances
- target groups
- load balancers
- RDS database
- Route 53 record

