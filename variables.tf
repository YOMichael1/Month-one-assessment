
variable "region" {
  description = "AWS region to deploy infrastructure"
  type        = string
  default     = "eu-west-1"
}

variable "my_ip" {
  description = "Your current IP address for bastion SSh access"
  type        = string
}

variable "key_pair_name" {
  description = "name of the AWS key pair to use for EC2 instances"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "web_instance_type" {
  description = "Instance Type for Web servers"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "Instance type for Database servers"
  type        = string
  default     = "t3.small"
}