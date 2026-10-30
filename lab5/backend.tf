terraform{
    backend "s3" {
        bucket = "terraform-state-devops-nr-2026"
        key    = "global/s3/terraform.tfstate"
        region = "ap-southeast-2"
        dynamodb_table = "terraform-locks"
        encrypt = true
    }
}