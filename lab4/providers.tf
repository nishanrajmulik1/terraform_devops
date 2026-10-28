# Configure the AWS Provider
provider "aws" {
  alias  = "first_region_australia"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "second_region_usa"
  region = "us-east-1"
}