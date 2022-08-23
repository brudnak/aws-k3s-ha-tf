output "instance_public_ip" {
  value = [for instance in aws_instance.aws_instance : "public IP for rke config: ${instance.public_ip}"]
}
output "instance_private_ip" {
  value = [for instance in aws_instance.aws_instance : "private IP for rke config: ${instance.private_ip}"]
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
