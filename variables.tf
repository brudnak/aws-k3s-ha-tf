variable "aws_prefix" {
  type        = string
  description = "The prefix for the resources."
}

variable "aws_region" {
  type        = string
  description = "The region to use."
  default     = "us-east-2"
}

variable "aws_access_key" {
  type        = string
  description = "The access key to use."
}

variable "aws_secret_key" {
  type        = string
  description = "The secret key to use."
}

variable "aws_vpc" {
  type        = string
  description = "The VPC to use."
}

variable "aws_subnet_a" {
  type        = string
  description = "The subnet A to use."
}

variable "aws_subnet_b" {
  type        = string
  description = "The subnet B to use."
}

variable "aws_subnet_c" {
  type        = string
  description = "The subnet C to use."
}

variable "aws_ami" {
  type        = string
  description = "The AMI to use."
}

variable "aws_subnet_id" {
  type        = string
  description = "The subnet ID to use."
}

variable "aws_security_group_id" {
  type        = string
  description = "The security group ID to use."
}

variable "aws_pem_key_name" {
  type        = string
  description = "The PEM key name to use."
}

variable "aws_rds_password" {
  type        = string
  description = "Password for the Amazon Aurora MySQL database."
}

variable "aws_route53_fqdn" {
  type        = string
  description = "The fully qualified domain name to use."
}

variable "local_path_aws_pem" {
  type        = string
  description = "Local machine path to pem file used to ssh into AWS instances."
}