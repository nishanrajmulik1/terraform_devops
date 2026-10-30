module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-my-vpc"
  cidr = "10.128.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets = ["10.128.1.0/24", "10.128.2.0/24", "10.128.3.0/24"]
  public_subnets  = ["10.128.101.0/24", "10.128.102.0/24", "10.128.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
