#1. Primary bucket -uses the default provider automatically
resource "aws_s3_bucket" "primary_data" {
  bucket = "nr-dev-primary-data-au-2026"
}

#2. DR bucket - explicitly references the aliased provider
resource "aws_s3_bucket" "secondary_data" {
  provider = aws.second_region_usa
  bucket   = "nr-dev-secondary-data-us-2026"
}

output "primary_bucket" {
  value = aws_s3_bucket.primary_data.region
}

output "secondary_bucket" {
  value = aws_s3_bucket.secondary_data.region
}


