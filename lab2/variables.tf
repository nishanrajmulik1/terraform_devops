variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-07887b6789db08b82" # Note: This is an Ubuntu AMI for ap-southeast-2. AMIs are region-specific!
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = "Terraform-Lab-2"
}

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "devcore"
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "non-prod"
}

locals {
  # Standard naming convention for resources
  name_prefix = "${var.project}-${var.environment}"
#   # Reusable tag set for all resources
#   common_tags = {
#     Environment = "var.environment"
#     project = "var.project"
#     ManagedBy = "Terraform"
#   }
}

variable "ingress_ports" {
  description = "List of ports to allow inbound traffic"
  type        = list(number)
  default     = [22, 80, 443, 5000, 8000]
}