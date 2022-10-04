# AWS k3s High Availability Terraform Infrastructure

## What is the purpose of this Terraform?

For Rancher QA to easily deploy and manage AWS infrastructure for k3s high availability testing. This creates everything you need in AWS to run k3s high availability with an external database. It creates ec2 instances, target groups, load balancers, RDS database, and Route 53 records. 

The k3s install commands are formatted for you and provided in the output.

All you have to do to get a full setup k3s high availability with external database is run 7 commands.

1. terraform apply
2. Run 6 commands that are formatted for you in the terraform output

## Just need to create an RKE1 high availability Rancher infrastructure? Check this repository out instead

https://github.com/brudnak/aws-ha-infra

## How to use it?

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
