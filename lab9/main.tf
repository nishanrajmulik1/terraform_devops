module "dev_bucket" {
    source = "./modules/custom_s3"
    bucket_name = "terra-my-s3-bucket-dev"
    environment = "dev"
}

module "prod_bucket" {
    source = "./modules/custom_s3"
    bucket_name = "terra-my-s3-bucket-prod"
    environment = "prod"
}

