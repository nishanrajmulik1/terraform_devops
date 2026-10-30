variable "instance_sizes" {
    type = map(string)
    default = {
        "default" = "t2.micro"
        "dev" = "t3.micro"
        "prod" = "t3.small"
    }    
}


variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-07887b6789db08b82" # Note: This is an Ubuntu AMI for ap-southeast-2. AMIs are region-specific!
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = "Terraform"
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
