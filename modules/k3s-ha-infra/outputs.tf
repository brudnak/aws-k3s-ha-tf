output "instance_public_ip" {
  value = [for instance in aws_instance.aws_instance : "public IP for rke config: ${instance.public_ip}"]
}
output "instance_private_ip" {
  value = [for instance in aws_instance.aws_instance : "private IP for rke config: ${instance.private_ip}"]
}

output "aws_route53_urls" {
  value = "your rancher URL: https://${aws_route53_record.aws_route53_record.fqdn}"
}


output "random_pet_id" {
  value = "random ID to identify aws resources: ${random_pet.random_pet.id}"
}

output "balancer_dns_name" {
  value = "load balancer to create DNS record with: ${aws_lb.aws_lb.dns_name}"
}

output "database_endpoint" {
  value = [for instance in aws_rds_cluster_instance.aws_rds_cluster_instance : "mysql://tfadmin:${var.aws_rds_password}@tcp(${instance.endpoint})/k3s"]
}

output "curl_command" {
  value = <<EOT

# START OF FIRST SERVER COMMANDS

# Step 1: SSH into your 1st server
ssh -i ${var.local_path_aws_pem} ubuntu@${aws_instance.aws_instance[0].public_ip}

# Step 2: Run this k3s install curl command
curl -sfL https://get.k3s.io | sh -s - server \
  --token=SECRET \
%{for instance in aws_rds_cluster_instance.aws_rds_cluster_instance}  --datastore-endpoint="mysql://tfadmin:${var.aws_rds_password}@tcp(${instance.endpoint})/k3s" \%{endfor}
  --tls-san ${aws_route53_record.aws_route53_record.fqdn} \
  --node-external-ip ${aws_instance.aws_instance[0].public_ip}

# Step 3: Copy the token from the following command to use with your 2nd server
sudo cat /var/lib/rancher/k3s/server/token

# Step 4: Get the kubeconfig for your setup
sudo cat /etc/rancher/k3s/k3s.yaml

# START OF SECOND SERVER COMMANDS *******************

# Step 1: SSH into your 2nd server
ssh -i ${var.local_path_aws_pem} ubuntu@${aws_instance.aws_instance[1].public_ip}

# Step 2: Run this k3s install curl command on this 2nd server
# MAKE SURE TO INCLUDE THE TOKEN FROM THE 1ST SERVER!!

echo 'curl -sfL https://get.k3s.io | sh -s - server --token= %{for instance in aws_rds_cluster_instance.aws_rds_cluster_instance} --datastore-endpoint="mysql://tfadmin:${var.aws_rds_password}@tcp(${instance.endpoint})/k3s"%{endfor} --tls-san ${aws_route53_record.aws_route53_record.fqdn} --node-external-ip ${aws_instance.aws_instance[1].public_ip}' | tee install.sh
EOT
}