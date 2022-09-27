# AWS k3s High Availability Terraform Infrastructure

## What is the purpose of this Terraform?

For Rancher QA to easily deploy and manage AWS infrastructure for k3s high availability testing. This creates a base level of infrastructure and outputs public, and private IP addresses for the various nodes. It also creates a MySQL connection string that's formatted and ready for the k3s install command.

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
```

## Output

Here is example output that you will receive after running the terraform. You can also get the values again anytime by running: `terraform output`

This Terraform creates two groups of infrastructure and is aimed at creating a hosted / tenant Rancher setup. The first group is the hosted Rancher infrastructure and the second group is the tenant Rancher infrastructure.

However it doesn't have to be solely used for Hosted / Tenant Rancher, and can just be used to spin up multiple k3s HA clusters.

```tf
ks3-ha-infra-host = {
  "balancer_dns_name" = "load balancer to create DNS record with: <load balancer dns name>"
  "database_endpoint" = [
    "<formatted mysql connection string that you can copy/paste into your k3s curl command>",
  ]
  "instance_private_ip" = [
    "private IP for rke config: 0.0.0.0",
    "private IP for rke config: 0.0.0.0",
  ]
  "instance_public_ip" = [
    "public IP for rke config: 0.0.0.0",
    "public IP for rke config: 0.0.0.0",
  ]
  "random_pet_id" = "random ID to identify aws resources: valid-beagle"
}
ks3-ha-infra-tenant = {
  "balancer_dns_name" = "load balancer to create DNS record with: <load balancer dns name>"
  "database_endpoint" = [
    "<formatted mysql connection string that you can copy/paste into your k3s curl command>",
  ]
  "instance_private_ip" = [
    "private IP for rke config: 0.0.0.0",
    "private IP for rke config: 0.0.0.0",
  ]
  "instance_public_ip" = [
    "public IP for rke config: 0.0.0.0",
    "public IP for rke config: 0.0.0.0",
  ]
  "random_pet_id" = "random ID to identify aws resources: superb-jawfish"
}
```

## What to do With the Terraform Output

Steps to create a high availability k3s cluster 

1. Crate a Route 53 record with the load balancer provided in the output
   - This can easily be added to the Terraform once you're comfortable with Terraform
   - I just use my own DNS / URLS
2. Follow the docs located at: https://rancher.com/docs/k3s/latest/en/installation/ha/
   1. The breakdown of these are:
   2. ssh into both of the public IP addresses from one of the setups
   3. On one of the nodes run this command

```shell
curl -sfL https://get.k3s.io | sh -s - server \
  --token=SECRET \
  --datastore-endpoint="copy-paste-your-mysql-connection-string-here-from-the-terraform-output" \
  --tls-san $MAKE_THIS_YOUR_ROUTE_53_URL \
  --node-external-ip $THIS_NODES_PUBLIC_IP
```

3. Once the command is done running you can get the token with

```shell
sudo cat /var/lib/rancher/k3s/server/token
```

4. Copy/save that token
5. On the other node run this command with the token in place of the SECRET

```shell
curl -sfL https://get.k3s.io | sh -s - server \
  --token=$THE_SECRET_YOU_COPIED_GOES_HERE \
  --datastore-endpoint="copy-paste-your-mysql-connection-string-here-from-the-terraform-output" \
  --tls-san $MAKE_THIS_YOUR_ROUTE_53_URL \
  --node-external-ip $THIS_NODES_PUBLIC_IP
```

6. To get the kubeconfig from k3s on your local follow this doc: https://rancher.com/docs/k3s/latest/en/cluster-access/

```shell
sudo cat /etc/rancher/k3s/k3s.yaml
```

7. Then replace the value of the server field with the public IP address of the node
8. Now you can install Rancher ontop of this setup following these docs: https://docs.ranchermanager.rancher.io/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster
9. Install cert manager and use let's encrypt however you'll need to change `--set letsEncrypt.ingress.class=nginx` to `--set letsEncrypt.ingress.class=traefik` in the helm install command


## Checks that Should be Done for Hosted/Tenant Rancher Release Testing
#### 📝 [Release Checklist](./markdown/release-checks.md)
